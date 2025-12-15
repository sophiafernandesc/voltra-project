import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/report_model.dart';

/// Serviço para gerenciar relatórios OBD no Firebase Firestore
///
/// Estrutura no Firestore:
/// users/{userId}/reports/{reportId}
class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Obtém o ID do usuário atual
  String? get currentUserId => _auth.currentUser?.uid;

  /// Referência para a coleção de relatórios do usuário atual
  CollectionReference<Map<String, dynamic>>? get _reportsCollection {
    final userId = currentUserId;
    if (userId == null) return null;
    return _firestore.collection('users').doc(userId).collection('reports');
  }

  /// Salva um relatório no Firestore
  /// Retorna o ID do documento criado
  Future<String?> saveReport(ReportModel report) async {
    try {
      final collection = _reportsCollection;
      if (collection == null) {
        throw Exception('Usuário não autenticado');
      }

      // Converte o modelo para o formato do Firestore
      final data = _toFirestoreData(report);

      // Usa o ID do relatório como ID do documento
      await collection.doc(report.id).set(data);

      return report.id;
    } catch (e) {
      print('Erro ao salvar relatório: $e');
      rethrow;
    }
  }

  /// Busca todos os relatórios do usuário
  Future<List<ReportModel>> getReports() async {
    try {
      final collection = _reportsCollection;
      if (collection == null) {
        return [];
      }

      final snapshot =
          await collection.orderBy('startTime', descending: true).get();

      return snapshot.docs
          .map((doc) => _fromFirestoreData(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Erro ao buscar relatórios: $e');
      return [];
    }
  }

  /// Busca um relatório específico por ID
  Future<ReportModel?> getReportById(String reportId) async {
    try {
      final collection = _reportsCollection;
      if (collection == null) return null;

      final doc = await collection.doc(reportId).get();
      if (!doc.exists) return null;

      return _fromFirestoreData(doc.data()!, doc.id);
    } catch (e) {
      print('Erro ao buscar relatório: $e');
      return null;
    }
  }

  /// Deleta um relatório
  Future<bool> deleteReport(String reportId) async {
    try {
      final collection = _reportsCollection;
      if (collection == null) return false;

      await collection.doc(reportId).delete();
      return true;
    } catch (e) {
      print('Erro ao deletar relatório: $e');
      return false;
    }
  }

  /// Stream de relatórios em tempo real
  Stream<List<ReportModel>> watchReports() {
    final collection = _reportsCollection;
    if (collection == null) {
      return Stream.value([]);
    }

    return collection.orderBy('startTime', descending: true).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => _fromFirestoreData(doc.data(), doc.id))
            .toList());
  }

  /// Converte ReportModel para formato Firestore
  /// Usa Timestamp do Firestore para datas
  Map<String, dynamic> _toFirestoreData(ReportModel report) {
    return {
      'startTime': Timestamp.fromDate(report.startTime),
      'endTime':
          report.endTime != null ? Timestamp.fromDate(report.endTime!) : null,
      'averageFuelConsumption': report.averageFuelConsumption,
      'averageSpeed': report.averageSpeed,
      'fuelType': report.fuelType,
      'currentFuelLevel': report.currentFuelLevel,
      'estimatedRange': report.estimatedRange,
      'totalDistance': report.totalDistance,
      'consumptionHistory': report.consumptionHistory
          .map((e) => {
                'distanceKm': e.distanceKm,
                'consumptionKmL': e.consumptionKmL,
                'timestamp': Timestamp.fromDate(e.timestamp),
              })
          .toList(),
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  /// Converte dados do Firestore para ReportModel
  ReportModel _fromFirestoreData(Map<String, dynamic> data, String docId) {
    return ReportModel(
      id: docId,
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: data['endTime'] != null
          ? (data['endTime'] as Timestamp).toDate()
          : null,
      averageFuelConsumption:
          (data['averageFuelConsumption'] ?? 0.0).toDouble(),
      averageSpeed: (data['averageSpeed'] ?? 0.0).toDouble(),
      fuelType: data['fuelType'] ?? '--',
      currentFuelLevel: (data['currentFuelLevel'] ?? 0.0).toDouble(),
      estimatedRange: (data['estimatedRange'] ?? 0.0).toDouble(),
      totalDistance: (data['totalDistance'] ?? 0.0).toDouble(),
      consumptionHistory: _parseConsumptionHistory(data['consumptionHistory']),
    );
  }

  /// Parse do histórico de consumo do Firestore
  List<ConsumptionDataPoint> _parseConsumptionHistory(dynamic data) {
    if (data == null) return [];

    return (data as List<dynamic>).map((e) {
      final map = e as Map<String, dynamic>;
      return ConsumptionDataPoint(
        distanceKm: (map['distanceKm'] ?? 0.0).toDouble(),
        consumptionKmL: (map['consumptionKmL'] ?? 0.0).toDouble(),
        timestamp: (map['timestamp'] as Timestamp).toDate(),
      );
    }).toList();
  }
}
