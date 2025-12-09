import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'user_model.dart'; // Importe seu modelo

class DatabaseHelper {
  // Singleton pattern (garante uma única instância do DB)
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inicializa o banco de dados
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_manager.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Cria a tabela quando o DB é criado pela primeira vez
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');
  }

  // --- Início das Funções do CRUD ---

  
  //C = CREATE (Criar) - Tela de cadastro
  Future<int> createUser(User user) async {
    final db = await database;
    // O .insert() retorna o ID do novo usuário
    return await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail, // Falha se o email (UNIQUE) já existir
    );
  }

  
  //R = READ (Ler) - Tela de login
  Future<bool> checkUserLogin(String email, String password) async {
    final db = await database;
    
    // ATENÇÃO: Lembre-se de hashear a senha 'password' antes de comparar
    
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    // Se a lista tiver algum resultado (maps.length > 0), o usuário existe
    return maps.isNotEmpty;
  }

  Future<User?> loginAndGetUser(String email, String password) async {
    final db = await database;
    //Colocar, depois, a senha hasheada no lugar de 'password' na consulta
    
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password], 
      limit: 1, // Queremos apenas 1 resultado
    );

    if (maps.isNotEmpty) {
      final data = maps.first;
      // Converte o Map do DB de volta para um objeto User
      return User(
        id: data['id'],
        firstName: data['firstName'],
        lastName: data['lastName'],
        email: data['email'],
        password: data['password'], // A senha não será usada, mas completamos o objeto
      );
    }
    
    // Se não encontrar (email ou senha errados), retorna nulo
    return null;
  }

  
  //U = UPDATE (Atualizar)
  Future<int> updateUserDetails(int id, String firstName, String lastName) async {
    final db = await database;

    // Usamos um Map nativo do Dart
    final values = <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
    };

    // O .update() retorna o número de linhas afetadas (deve ser 1)
    return await db.update(
      'users',               // Tabela
      values,                // Novos valores (o Map)
      where: 'id = ?',             
      whereArgs: [id.toString()],       
    );
  }

  
  //D = DELETE (Deletar)
  Future<int> deleteUser(int id) async {
    final db = await database;
    
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id.toString()],
    );
  }
}