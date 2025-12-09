class User {
  final int? id; // Pode ser nulo se ainda não foi salvo no DB
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  User({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  // Converte um User em um Map (para inserir no DB)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
    };
  }
}