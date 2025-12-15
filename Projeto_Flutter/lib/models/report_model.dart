/// Modelo de dados para o relatório do veículo OBD2
/// Este modelo armazena todas as informações coletadas durante uma sessão
class ReportModel {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final double averageFuelConsumption; // Km/L
  final double averageSpeed; // Km/h
  final String fuelType;
  final double currentFuelLevel; // %
  final double estimatedRange; // Km
  final double totalDistance; // Km
  final List<ConsumptionDataPoint> consumptionHistory;

  ReportModel({
    required this.id,
    required this.startTime,
    this.endTime,
    this.averageFuelConsumption = 0.0,
    this.averageSpeed = 0.0,
    this.fuelType = '--',
    this.currentFuelLevel = 0.0,
    this.estimatedRange = 0.0,
    this.totalDistance = 0.0,
    this.consumptionHistory = const [],
  });

  /// Converte para JSON para persistência
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'averageFuelConsumption': averageFuelConsumption,
      'averageSpeed': averageSpeed,
      'fuelType': fuelType,
      'currentFuelLevel': currentFuelLevel,
      'estimatedRange': estimatedRange,
      'totalDistance': totalDistance,
      'consumptionHistory': consumptionHistory.map((e) => e.toJson()).toList(),
    };
  }

  /// Cria um ReportModel a partir de JSON
  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] ?? '',
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      averageFuelConsumption:
          (json['averageFuelConsumption'] ?? 0.0).toDouble(),
      averageSpeed: (json['averageSpeed'] ?? 0.0).toDouble(),
      fuelType: json['fuelType'] ?? '--',
      currentFuelLevel: (json['currentFuelLevel'] ?? 0.0).toDouble(),
      estimatedRange: (json['estimatedRange'] ?? 0.0).toDouble(),
      totalDistance: (json['totalDistance'] ?? 0.0).toDouble(),
      consumptionHistory: (json['consumptionHistory'] as List<dynamic>?)
              ?.map((e) => ConsumptionDataPoint.fromJson(e))
              .toList() ??
          [],
    );
  }

  /// Cria uma cópia do modelo com campos atualizados
  ReportModel copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    double? averageFuelConsumption,
    double? averageSpeed,
    String? fuelType,
    double? currentFuelLevel,
    double? estimatedRange,
    double? totalDistance,
    List<ConsumptionDataPoint>? consumptionHistory,
  }) {
    return ReportModel(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      averageFuelConsumption:
          averageFuelConsumption ?? this.averageFuelConsumption,
      averageSpeed: averageSpeed ?? this.averageSpeed,
      fuelType: fuelType ?? this.fuelType,
      currentFuelLevel: currentFuelLevel ?? this.currentFuelLevel,
      estimatedRange: estimatedRange ?? this.estimatedRange,
      totalDistance: totalDistance ?? this.totalDistance,
      consumptionHistory: consumptionHistory ?? this.consumptionHistory,
    );
  }
}

/// Ponto de dados para o gráfico de consumo
class ConsumptionDataPoint {
  final double distanceKm; // Distância percorrida (eixo X)
  final double consumptionKmL; // Consumo em Km/L (eixo Y)
  final DateTime timestamp;

  ConsumptionDataPoint({
    required this.distanceKm,
    required this.consumptionKmL,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'distanceKm': distanceKm,
      'consumptionKmL': consumptionKmL,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ConsumptionDataPoint.fromJson(Map<String, dynamic> json) {
    return ConsumptionDataPoint(
      distanceKm: (json['distanceKm'] ?? 0.0).toDouble(),
      consumptionKmL: (json['consumptionKmL'] ?? 0.0).toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
