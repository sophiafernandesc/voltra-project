import 'dart:async';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart' hide LatLng;
import '/app_state.dart';
import 'package:flutter/material.dart';

// O import do Core não é mais estritamente necessário aqui, mas mal não faz
import 'package:firebase_core/firebase_core.dart'; 

import 'package:firebase_database/firebase_database.dart'; 
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; 

import 'map_tracker_screen_model.dart';
export 'map_tracker_screen_model.dart';

class MapTrackerScreenWidget extends StatefulWidget {
  const MapTrackerScreenWidget({super.key});

  static String routeName = 'MapTrackerScreen';
  static String routePath = '/mapTrackerScreen';

  @override
  State<MapTrackerScreenWidget> createState() => _MapTrackerScreenWidgetState();
}

class _MapTrackerScreenWidgetState extends State<MapTrackerScreenWidget> {
  late MapTrackerScreenModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  StreamSubscription<DatabaseEvent>? _trackerSubscription;

  // Variáveis para o Painel de Diagnóstico Visual
  String _debugLog = "Iniciando...";
  String _targetId = "";

  // SEU TOKEN MAPBOX
  final String mapboxAccessToken = 'pk.eyJ1IjoiYnJ1bm9kb3Rjb20iLCJhIjoiY200M3Z6ZjE5MGt3MjJqc2J6MTN2eHk4MSJ9.s4w-LwX5Z-aGv5G3l0r2mA'; 
  final String mapboxStyleId = 'mapbox/streets-v12'; 

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MapTrackerScreenModel());
    _startListeningToTracker();
  }

  @override
  void dispose() {
    _trackerSubscription?.cancel();
    _model.dispose();
    super.dispose();
  }

  void _addLog(String msg) {
    print("[MAP DEBUG] $msg");
    if (mounted) {
      setState(() {
        _debugLog = "$msg\n$_debugLog"; 
      });
    }
  }

  void _startListeningToTracker() {
    _targetId = FFAppState().trackerId;
    _addLog("Buscando ID: '$_targetId'");

    if (_targetId.isEmpty) {
      _addLog("ERRO CRÍTICO: ID Vazio. Faça login novamente.");
      return;
    }

    String path = 'rastreador/$_targetId';
    _addLog("Caminho no Banco: $path");

    // [LIMPEZA] Agora voltamos ao padrão, pois o firebase_options já tem a URL certa!
    DatabaseReference ref = FirebaseDatabase.instance.ref(path);

    _trackerSubscription = ref.onValue.listen((event) {
      if (!event.snapshot.exists) {
        _addLog("Conectado, mas SEM DADOS nesse caminho.");
        _addLog("Verifique se o ID '$_targetId' existe no banco.");
        return;
      }

      if (event.snapshot.value == null) {
        _addLog("Dados recebidos são NULOS.");
        return;
      }

      _addLog("Dados RAW recebidos: ${event.snapshot.value}");

      try {
        final data = Map<dynamic, dynamic>.from(event.snapshot.value as Map);
        var latRaw = data['lat'];
        var lngRaw = data['lng'];

        if (latRaw == null || lngRaw == null) {
          _addLog("ERRO: Campos 'lat' ou 'lng' não encontrados no JSON.");
          return;
        }

        double? lat = double.tryParse(latRaw.toString());
        double? lng = double.tryParse(lngRaw.toString());

        if (lat != null && lng != null) {
          _addLog("Sucesso! Lat: $lat, Lng: $lng");
          _updateMapLocation(lat, lng);
        } else {
          _addLog("Erro ao converter números.");
        }

      } catch (e) {
        _addLog("Erro ao processar JSON: $e");
      }

    }, onError: (error) {
      _addLog("ERRO FIREBASE: $error");
    });
  }

  void _updateMapLocation(double lat, double lng) {
    LatLng newPos = LatLng(lat, lng);
    
    if (_model.currentPosition != newPos) {
        if (mounted) {
          setState(() {
            _model.currentPosition = newPos;
            _model.statusText = "Sinal: $lat, $lng";
          });
        }
        _model.mapController.move(newPos, 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: true,
          title: Text('Rastreamento', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              // 1. O MAPA (Camada de Fundo)
              Column(
                children: [
                  Expanded(
                    child: FlutterMap(
                      mapController: _model.mapController,
                      options: MapOptions(
                        initialCenter: _model.currentPosition ?? LatLng(-19.8157, -43.9542),
                        initialZoom: 14.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: "https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}",
                          additionalOptions: {
                            'accessToken': mapboxAccessToken,
                            'id': mapboxStyleId,
                          },
                        ),
                        if (_model.currentPosition != null)
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: _model.currentPosition!,
                                width: 50,
                                height: 50,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black26)],
                                  ),
                                  child: Icon(Icons.directions_car, color: Colors.blue, size: 30),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),

              // 2. PAINEL DE DIAGNÓSTICO (Camada da Frente)
              Positioned(
                top: 10,
                left: 10,
                right: 10,
                child: Container(
                  height: 150,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "PAINEL DE DIAGNÓSTICO (DEBUG)",
                          style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        Divider(color: Colors.white30, height: 10),
                        Text(
                          _debugLog,
                          style: TextStyle(color: Colors.white, fontSize: 11, fontFamily: 'Courier'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}