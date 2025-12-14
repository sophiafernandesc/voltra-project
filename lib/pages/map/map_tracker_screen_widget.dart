import 'dart:async';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart' hide LatLng;
import '/app_state.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'package:firebase_database/firebase_database.dart'; 
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; 

// [NOVO] Importamos os segredos
import '/secrets.dart';

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

  // Debug
  String _debugLog = "Iniciando...";
  String _targetId = "";

  // [CORREÇÃO] Usamos a constante global aqui
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
      _addLog("ERRO CRÍTICO: ID Vazio.");
      return;
    }

    String path = 'rastreador/$_targetId';
    DatabaseReference ref = FirebaseDatabase.instance.ref(path);

    _trackerSubscription = ref.onValue.listen((event) {
      if (!event.snapshot.exists) return;
      if (event.snapshot.value == null) return;

      try {
        final data = Map<dynamic, dynamic>.from(event.snapshot.value as Map);
        var latRaw = data['lat'];
        var lngRaw = data['lng'];

        if (latRaw != null && lngRaw != null) {
          double? lat = double.tryParse(latRaw.toString());
          double? lng = double.tryParse(lngRaw.toString());

          if (lat != null && lng != null) {
            _updateMapLocation(lat, lng);
          }
        }
      } catch (e) {
        _addLog("Erro JSON: $e");
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
                          // [CORREÇÃO] Usamos a chave segura
                          urlTemplate: "https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=$kMapboxAccessToken",
                          additionalOptions: {
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
                                child: Icon(Icons.directions_car, color: Colors.blue, size: 30),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}