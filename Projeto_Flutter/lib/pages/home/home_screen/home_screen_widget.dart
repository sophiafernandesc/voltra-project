import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../models/report_model.dart';
import '../../../services/report_service.dart';

/// Ponto de entrada da aplicação
/// Inicia um MaterialApp com a ObdPage como tela inicial
void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ObdPage(),
  ));
}

/// Página principal que gerencia a conexão Bluetooth com dispositivo OBD-II
/// e exibe dados do veículo em tempo real
class ObdPage extends StatefulWidget {
  static String routeName = 'HomeScreen';
  static String routePath = '/homeScreen';
  const ObdPage({Key? key}) : super(key: key);

  @override
  State<ObdPage> createState() => _ObdPageState();
}

class _ObdPageState extends State<ObdPage> {
  // ==================== CONEXÃO BLUETOOTH ====================
  BluetoothConnection? connection;
  bool isConnecting = false;
  bool isConnected = false;
  String statusMessage = "";
  Timer? timer;
  StreamSubscription? subscription;
  String buffer = "";

  // ==================== MODO DE SIMULAÇÃO ====================
  bool simulationMode = false;
  Timer? simulationTimer;

  // ==================== FIREBASE ====================
  final ReportService _reportService = ReportService();
  bool isSaving = false;

  // ==================== DADOS DO VEÍCULO ====================
  String speedValue = "--";
  String fuelLevelValue = "--";
  String fuelTypeValue = "--";

  // ==================== DADOS PARA CÁLCULOS ====================
  double tankCapacityLiters = 50.0; // Capacidade do tanque padrão
  double totalDistance = 0.0; // Distância total percorrida (km)
  double totalFuelUsed = 0.0; // Total de combustível usado (L)
  double lastFuelLevel = -1.0; // Último nível de combustível lido (%)
  double lastSpeed = 0.0; // Última velocidade lida
  DateTime? lastReadingTime; // Timestamp da última leitura

  List<double> speedReadings = []; // Histórico de velocidades para média
  List<ConsumptionDataPoint> consumptionHistory = []; // Histórico para gráfico

  DateTime? reportStartTime; // Início do relatório atual

  @override
  void initState() {
    super.initState();
    checkBluetoothAndPermissions();
  }

  @override
  void dispose() {
    timer?.cancel();
    simulationTimer?.cancel();
    subscription?.cancel();
    connection?.dispose();
    super.dispose();
  }

  // ==================== GETTERS CALCULADOS ====================

  /// Consumo médio em Km/L
  double get averageFuelConsumption {
    if (totalFuelUsed <= 0) return 0.0;
    return totalDistance / totalFuelUsed;
  }

  /// Velocidade média em Km/h
  double get averageSpeed {
    if (speedReadings.isEmpty) return 0.0;
    return speedReadings.reduce((a, b) => a + b) / speedReadings.length;
  }

  /// Autonomia estimada em Km
  double get estimatedRange {
    if (fuelLevelValue == "--" || averageFuelConsumption <= 0) return 0.0;
    double currentFuelPercent = double.tryParse(fuelLevelValue) ?? 0.0;
    double currentFuelLiters = (currentFuelPercent / 100) * tankCapacityLiters;
    return currentFuelLiters * averageFuelConsumption;
  }

  // ==================== BLUETOOTH E PERMISSÕES ====================

  Future<void> checkBluetoothAndPermissions() async {
    bool? isAvailable = await FlutterBluetoothSerial.instance.isAvailable;

    if (isAvailable == null || !isAvailable) {
      setState(() {
        statusMessage = "Bluetooth não disponível neste dispositivo";
      });
      return;
    }

    bool? isEnabled = await FlutterBluetoothSerial.instance.isEnabled;

    if (isEnabled == null || !isEnabled) {
      setState(() {
        statusMessage = "Bluetooth desligado. Ativando...";
      });

      await FlutterBluetoothSerial.instance.requestEnable();
    }
  }

  Future<bool> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    bool allGranted = statuses.values.every((status) => status.isGranted);

    if (!allGranted) {
      setState(() {
        statusMessage = "Permissões negadas. Ative nas configurações.";
      });

      if (statuses.values.any((status) => status.isPermanentlyDenied)) {
        await openAppSettings();
      }
    }

    return allGranted;
  }

  Future<void> connectToObd() async {
    setState(() {
      isConnecting = true;
      statusMessage = "Verificando permissões...";
    });

    bool hasPermissions = await requestPermissions();

    if (!hasPermissions) {
      setState(() => isConnecting = false);
      return;
    }

    try {
      setState(() => statusMessage = "Buscando dispositivos pareados...");

      List<BluetoothDevice> devices =
          await FlutterBluetoothSerial.instance.getBondedDevices();

      if (devices.isEmpty) {
        setState(() {
          statusMessage =
              "Nenhum dispositivo pareado encontrado.\nPareie o OBD2 primeiro nas configurações Bluetooth.";
          isConnecting = false;
        });
        return;
      }

      debugPrint("Dispositivos encontrados:");
      for (var device in devices) {
        debugPrint("- ${device.name} (${device.address})");
      }

      final obdDevice = devices.firstWhere(
        (d) => d.name?.toUpperCase().contains("OBD") ?? false,
        orElse: () => devices.first,
      );

      setState(() => statusMessage = "Conectando a ${obdDevice.name}...");

      connection = await BluetoothConnection.toAddress(obdDevice.address);

      setState(() => statusMessage = "Inicializando ELM327...");

      setupBluetoothListener();
      await initObd();

      setState(() {
        isConnected = true;
        isConnecting = false;
        statusMessage = "Conectado!";
        reportStartTime = DateTime.now();
      });

      await Future.delayed(const Duration(seconds: 1));
      startReadingObdData();
    } catch (e) {
      setState(() {
        isConnecting = false;
        statusMessage = "Erro: $e";
      });
      debugPrint("Erro ao conectar: $e");
    }
  }

  // ==================== MODO DE SIMULAÇÃO ====================

  void startSimulationMode() {
    setState(() {
      simulationMode = true;
      isConnected = true;
      statusMessage = "Modo Simulação Ativo";
      reportStartTime = DateTime.now();
    });

    final random = Random();
    double simulatedFuel = 75.0; // Começa com 75% do tanque
    double simulatedSpeed = 0.0;
    simulationTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      // Simula variação de velocidade
      simulatedSpeed = 30 + random.nextDouble() * 90; // 30-120 km/h

      // Simula variação de combustível (consome lentamente)
      simulatedFuel -= random.nextDouble() * 0.2; // Consome 0-0.2% por ciclo
      if (simulatedFuel < 5) simulatedFuel = 75; // Reseta quando muito baixo

      setState(() {
        speedValue = simulatedSpeed.toStringAsFixed(0);
        fuelLevelValue = simulatedFuel.toStringAsFixed(1);
        fuelTypeValue = "Gasolina";

        // Atualiza cálculos
        _updateCalculations(simulatedSpeed, simulatedFuel);
      });
    });
  }

  void stopSimulationMode() {
    simulationTimer?.cancel();
    setState(() {
      simulationMode = false;
      isConnected = false;
      _resetData();
    });
  }

  // ==================== LISTENER BLUETOOTH ====================

  void setupBluetoothListener() {
    subscription = connection!.input?.listen(
      (data) {
        buffer += utf8.decode(data);

        if (buffer.contains('>')) {
          final lines = buffer.split('>');

          for (int i = 0; i < lines.length - 1; i++) {
            processObdResponse(lines[i].trim());
          }

          buffer = lines.last;
        }
      },
      onDone: () {
        debugPrint("Conexão encerrada");
        setState(() {
          isConnected = false;
          statusMessage = "Conexão perdida";
        });
      },
      onError: (error) {
        debugPrint("Erro no stream: $error");
      },
    );
  }

  void processObdResponse(String response) {
    debugPrint("Resposta OBD: $response");

    final cleaned = response.replaceAll(RegExp(r'\s+'), ' ').trim();

    // Velocidade (PID 0D)
    if (cleaned.contains('41 0D') || cleaned.contains('410D')) {
      final speed = parseSpeed(cleaned);
      if (speed != null) {
        debugPrint("✅ Velocidade parseada: $speed");
        setState(() {
          speedValue = speed.toStringAsFixed(0);
          _updateCalculations(speed, null);
        });
      }
    }

    // Nível de Combustível (PID 2F)
    if (cleaned.contains('41 2F') || cleaned.contains('412F')) {
      final fuelLevel = parseFuelLevel(cleaned);
      if (fuelLevel != null) {
        debugPrint("✅ Nível de combustível parseado: $fuelLevel");
        setState(() {
          fuelLevelValue = fuelLevel.toStringAsFixed(1);
          _updateCalculations(null, fuelLevel);
        });
      }
    }

    // Tipo de Combustível (PID 51)
    if (cleaned.contains('41 51') || cleaned.contains('4151')) {
      final fuelType = parseFuelType(cleaned);
      if (fuelType != null) {
        debugPrint("✅ Tipo de combustível parseado: $fuelType");
        setState(() {
          fuelTypeValue = fuelType;
        });
      }
    }
  }

  /// Atualiza os cálculos de consumo e distância
  void _updateCalculations(double? newSpeed, double? newFuelLevel) {
    final now = DateTime.now();

    // Atualiza velocidade e calcula distância
    if (newSpeed != null) {
      speedReadings.add(newSpeed);

      // Limita histórico de velocidades a 1000 leituras
      if (speedReadings.length > 1000) {
        speedReadings.removeAt(0);
      }

      // Calcula distância percorrida desde última leitura
      if (lastReadingTime != null && lastSpeed > 0) {
        double timeHours = now.difference(lastReadingTime!).inSeconds / 3600;
        double avgSpeed = (lastSpeed + newSpeed) / 2;
        totalDistance += avgSpeed * timeHours;
      }

      lastSpeed = newSpeed;
      lastReadingTime = now;
    }

    // Atualiza consumo de combustível
    if (newFuelLevel != null) {
      if (lastFuelLevel >= 0 && newFuelLevel < lastFuelLevel) {
        // Combustível foi consumido
        double fuelConsumedPercent = lastFuelLevel - newFuelLevel;
        double fuelConsumedLiters =
            (fuelConsumedPercent / 100) * tankCapacityLiters;
        totalFuelUsed += fuelConsumedLiters;

        // Adiciona ponto ao gráfico de consumo
        if (totalDistance > 0 && totalFuelUsed > 0) {
          consumptionHistory.add(ConsumptionDataPoint(
            distanceKm: totalDistance,
            consumptionKmL: averageFuelConsumption,
            timestamp: now,
          ));

          // Limita histórico do gráfico a 50 pontos
          if (consumptionHistory.length > 50) {
            consumptionHistory.removeAt(0);
          }
        }
      }

      lastFuelLevel = newFuelLevel;
    }
  }

  // ==================== INICIALIZAÇÃO OBD ====================

  Future<void> initObd() async {
    try {
      await sendCommand("ATZ");
      await Future.delayed(const Duration(seconds: 2));

      await sendCommand("ATE0");
      await Future.delayed(const Duration(milliseconds: 500));

      await sendCommand("ATL0");
      await Future.delayed(const Duration(milliseconds: 500));

      await sendCommand("ATS0");
      await Future.delayed(const Duration(milliseconds: 500));

      await sendCommand("ATH0");
      await Future.delayed(const Duration(milliseconds: 500));

      await sendCommand("ATSP0");
      await Future.delayed(const Duration(milliseconds: 1000));

      debugPrint("ELM327 inicializado");
    } catch (e) {
      debugPrint("Erro na inicialização: $e");
      rethrow;
    }
  }

  Future<void> sendCommand(String cmd) async {
    if (connection == null || !connection!.isConnected) {
      throw Exception("Não conectado");
    }

    debugPrint("Enviando: $cmd");
    connection!.output.add(utf8.encode("$cmd\r"));
    await connection!.output.allSent;
  }

  void startReadingObdData() {
    int commandIndex = 0;
    final commands = [
      "010D", // Velocidade
      "012F", // Nível de combustível
      "0151", // Tipo de combustível
    ];

    timer = Timer.periodic(const Duration(milliseconds: 1500), (_) async {
      if (connection != null && connection!.isConnected) {
        try {
          await sendCommand(commands[commandIndex % commands.length]);
          commandIndex++;
        } catch (e) {
          debugPrint("Erro ao enviar comando: $e");
          timer?.cancel();
        }
      } else {
        timer?.cancel();
      }
    });
  }

  // ==================== PARSERS ====================

  double? parseSpeed(String raw) {
    final match = RegExp(r"41\s?0D\s?([0-9A-F]{2})", caseSensitive: false)
        .firstMatch(raw);

    if (match != null) {
      try {
        final speed = int.parse(match.group(1)!, radix: 16);
        return speed.toDouble();
      } catch (e) {
        debugPrint("Erro ao parsear velocidade: $e");
        return null;
      }
    }
    return null;
  }

  double? parseFuelLevel(String raw) {
    final match = RegExp(r"41\s?2F\s?([0-9A-F]{2})", caseSensitive: false)
        .firstMatch(raw);

    if (match != null) {
      try {
        final fuelByte = int.parse(match.group(1)!, radix: 16);
        return (fuelByte / 255.0) * 100.0;
      } catch (e) {
        debugPrint("Erro ao parsear nível de combustível: $e");
        return null;
      }
    }
    return null;
  }

  String? parseFuelType(String raw) {
    final match = RegExp(r"41\s?51\s?([0-9A-F]{2})", caseSensitive: false)
        .firstMatch(raw);

    if (match != null) {
      try {
        final fuelTypeByte = int.parse(match.group(1)!, radix: 16);

        const fuelTypes = {
          0: "Não disponível",
          1: "Gasolina",
          2: "Metanol",
          3: "Etanol",
          4: "Diesel",
          5: "GLP",
          6: "GNV",
          7: "Propano",
          8: "Elétrico",
          9: "Flex (Gasolina/Etanol)",
          10: "Diesel/Etanol",
          11: "GLP/GNV",
          12: "E85",
          13: "Diesel B20",
          14: "Diesel B99",
          15: "Diesel RME",
          16: "Transportador",
        };

        return fuelTypes[fuelTypeByte] ?? "Desconhecido";
      } catch (e) {
        debugPrint("Erro ao parsear tipo de combustível: $e");
        return null;
      }
    }
    return null;
  }

  // ==================== RESET E SAVE ====================

  void _resetData() {
    speedValue = "--";
    fuelLevelValue = "--";
    fuelTypeValue = "--";
    totalDistance = 0.0;
    totalFuelUsed = 0.0;
    lastFuelLevel = -1.0;
    lastSpeed = 0.0;
    lastReadingTime = null;
    speedReadings.clear();
    consumptionHistory.clear();
    reportStartTime = null;
    statusMessage = "";
  }

  void disconnect() {
    timer?.cancel();
    subscription?.cancel();
    connection?.finish();

    setState(() {
      isConnected = false;
      _resetData();
    });
  }

  /// Salva o relatório atual no Firestore e inicia um novo
  Future<void> saveReportAndReset() async {
    if (isSaving) return; // Evita duplo clique

    setState(() {
      isSaving = true;
    });

    // Cria o relatório com os dados atuais
    final report = ReportModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startTime: reportStartTime ?? DateTime.now(),
      endTime: DateTime.now(),
      averageFuelConsumption: averageFuelConsumption,
      averageSpeed: averageSpeed,
      fuelType: fuelTypeValue,
      currentFuelLevel: double.tryParse(fuelLevelValue) ?? 0.0,
      estimatedRange: estimatedRange,
      totalDistance: totalDistance,
      consumptionHistory: List.from(consumptionHistory),
    );

    try {
      // Salva no Firebase Firestore
      final savedId = await _reportService.saveReport(report);

      if (savedId != null) {
        debugPrint("✅ Relatório salvo no Firestore com ID: $savedId");

        // Mostra confirmação de sucesso
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.cloud_done, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Relatório salvo! Distância: ${totalDistance.toStringAsFixed(1)} km, '
                      'Consumo: ${averageFuelConsumption.toStringAsFixed(1)} Km/L',
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }

        // Reseta os dados para novo relatório
        setState(() {
          totalDistance = 0.0;
          totalFuelUsed = 0.0;
          lastFuelLevel = double.tryParse(fuelLevelValue) ?? -1.0;
          speedReadings.clear();
          consumptionHistory.clear();
          reportStartTime = DateTime.now();
        });
      } else {
        throw Exception('Falha ao salvar - usuário não autenticado');
      }
    } catch (e) {
      debugPrint("❌ Erro ao salvar relatório: $e");

      // Mostra erro
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Erro ao salvar: $e'),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  // ==================== WIDGETS DE UI ====================

  Widget _buildDataCard({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    List<Color>? gradientColors,
  }) {
    final colors = gradientColors ?? [Colors.blue[400]!, Colors.blue[600]!];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors[0].withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$value $unit",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsumptionChart() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Histórico de Consumo",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: consumptionHistory.isEmpty
                ? const Center(
                    child: Text(
                      "Aguardando dados...",
                      style: TextStyle(color: Colors.white38),
                    ),
                  )
                : LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 5,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Colors.white12,
                          strokeWidth: 1,
                        ),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 35,
                            getTitlesWidget: (value, meta) => Text(
                              '${value.toInt()}',
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 22,
                            getTitlesWidget: (value, meta) => Text(
                              '${value.toInt()}km',
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: consumptionHistory
                              .map(
                                  (e) => FlSpot(e.distanceKm, e.consumptionKmL))
                              .toList(),
                          isCurved: true,
                          color: Colors.greenAccent,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.greenAccent.withOpacity(0.2),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ==================== BUILD ====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[800]!, Colors.blue[600]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo e título
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.directions_car,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "VOLTRA",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          Text(
                            "Dashboard OBD2",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Status de conexão
                  if (isConnected)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: simulationMode
                            ? Colors.orange.withValues(alpha: 0.2)
                            : Colors.green.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: simulationMode ? Colors.orange : Colors.green,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            simulationMode
                                ? Icons.bug_report
                                : Icons.bluetooth_connected,
                            color:
                                simulationMode ? Colors.orange : Colors.green,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            simulationMode ? "Simulação" : "Conectado",
                            style: TextStyle(
                              color:
                                  simulationMode ? Colors.orange : Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isConnected ? _buildConnectedView() : _buildDisconnectedView(),
      ),
    );
  }

  Widget _buildConnectedView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Título e status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Relatório do Veículo",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (reportStartTime != null)
                Text(
                  "Início: ${_formatTime(reportStartTime!)}",
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Row 1: Consumo Médio e Velocidade Média
          Row(
            children: [
              Expanded(
                child: _buildDataCard(
                  title: "Consumo Médio",
                  value: averageFuelConsumption > 0
                      ? averageFuelConsumption.toStringAsFixed(1)
                      : "--",
                  unit: "Km/L",
                  icon: Icons.local_gas_station,
                  gradientColors: [Colors.green[400]!, Colors.green[700]!],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDataCard(
                  title: "Velocidade Média",
                  value:
                      averageSpeed > 0 ? averageSpeed.toStringAsFixed(0) : "--",
                  unit: "Km/h",
                  icon: Icons.speed,
                  gradientColors: [Colors.blue[400]!, Colors.blue[700]!],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Gráfico de Consumo
          _buildConsumptionChart(),
          const SizedBox(height: 16),

          // Row 2: Velocidade Atual e Nível de Combustível
          Row(
            children: [
              Expanded(
                child: _buildDataCard(
                  title: "Velocidade Atual",
                  value: speedValue,
                  unit: "Km/h",
                  icon: Icons.speed_outlined,
                  gradientColors: [Colors.purple[400]!, Colors.purple[700]!],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDataCard(
                  title: "Nível Tanque",
                  value: fuelLevelValue,
                  unit: "%",
                  icon: Icons.local_gas_station_outlined,
                  gradientColors: [Colors.amber[600]!, Colors.amber[900]!],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Row 3: Tipo de Combustível e Autonomia
          Row(
            children: [
              Expanded(
                child: _buildDataCard(
                  title: "Combustível",
                  value: fuelTypeValue,
                  unit: "",
                  icon: Icons.opacity,
                  gradientColors: [Colors.teal[400]!, Colors.teal[700]!],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDataCard(
                  title: "Autonomia Est.",
                  value: estimatedRange > 0
                      ? estimatedRange.toStringAsFixed(0)
                      : "--",
                  unit: "Km",
                  icon: Icons.route,
                  gradientColors: [Colors.orange[400]!, Colors.orange[700]!],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Distância percorrida
          _buildDataCard(
            title: "Distância Percorrida",
            value: totalDistance > 0 ? totalDistance.toStringAsFixed(1) : "0.0",
            unit: "Km",
            icon: Icons.straighten,
            gradientColors: [Colors.indigo[400]!, Colors.indigo[700]!],
          ),
          const SizedBox(height: 24),

          // Botões de ação
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: saveReportAndReset,
                  icon: const Icon(Icons.save),
                  label: const Text("Salvar e Novo Relatório"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: simulationMode ? stopSimulationMode : disconnect,
                  icon: const Icon(Icons.power_settings_new),
                  label: const Text("Desconectar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDisconnectedView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Ícone Bluetooth
        Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.bluetooth,
            size: 80,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(height: 30),

        // Título
        const Text(
          "Conectar ao ELM327",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),

        Text(
          "Conecte-se ao seu dispositivo OBD2 para\nvisualizar os dados do veículo",
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),

        // Botão de conexão
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: isConnecting ? null : connectToObd,
            icon: const Icon(Icons.bluetooth_searching),
            label: Text(
              isConnecting ? "Conectando..." : "Conectar ao OBD2",
              style: const TextStyle(fontSize: 18),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Botão modo simulação
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: startSimulationMode,
            icon: const Icon(Icons.bug_report),
            label: const Text(
              "Modo Simulação (Debug)",
              style: TextStyle(fontSize: 16),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.orange,
              side: const BorderSide(color: Colors.orange),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),

        // Mensagem de status
        if (statusMessage.isNotEmpty) ...[
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  statusMessage.contains("Erro")
                      ? Icons.error_outline
                      : Icons.info_outline,
                  color: statusMessage.contains("Erro")
                      ? Colors.redAccent
                      : Colors.blueAccent,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    statusMessage,
                    style: TextStyle(
                      color: statusMessage.contains("Erro")
                          ? Colors.redAccent
                          : Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }
}
