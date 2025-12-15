import 'dart:async';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';


import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart'; 

import 'tracker_info_screen_model.dart';
export 'tracker_info_screen_model.dart';

class TrackerInfoScreenWidget extends StatefulWidget {
  const TrackerInfoScreenWidget({super.key});

  static String routeName = 'TrackerInfoScreen';
  static String routePath = '/trackerInfoScreen';

  @override
  State<TrackerInfoScreenWidget> createState() => _TrackerInfoScreenWidgetState();
}

class _TrackerInfoScreenWidgetState extends State<TrackerInfoScreenWidget> {
  late TrackerInfoScreenModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  StreamSubscription<DatabaseEvent>? _trackerSubscription;
  Timer? _offlineTimer;
  DateTime? _lastSignalTime;
  final int _timeoutSeconds = 10; 

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TrackerInfoScreenModel());
    _startMonitoring();
  }

  @override
  void dispose() {
    _trackerSubscription?.cancel();
    _offlineTimer?.cancel();
    _model.dispose();
    super.dispose();
  }

  void _startMonitoring() {
    String trackerId = FFAppState().trackerId;

    if (trackerId.isEmpty) {
      if (mounted) setState(() => _model.lastSeenText = "ID não configurado");
      return;
    }

    DatabaseReference ref = FirebaseDatabase.instance.ref('rastreador/$trackerId');

    _trackerSubscription = ref.onValue.listen((event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        _lastSignalTime = DateTime.now();
        
        final data = Map<dynamic, dynamic>.from(event.snapshot.value as Map);
        var lat = double.tryParse(data['lat'].toString());
        var lng = double.tryParse(data['lng'].toString());

        if (mounted) {
          setState(() {
            _model.isOnline = true; 
            _model.lastSeenText = DateFormat('HH:mm:ss').format(_lastSignalTime!);
            
            if (lat != null && lng != null) {
              _model.tempLat = lat;
              _model.tempLng = lng;
            }
          });
        }
      }
    });

    _offlineTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (_lastSignalTime != null) {
        final timeDiff = DateTime.now().difference(_lastSignalTime!).inSeconds;
        
        if (timeDiff > _timeoutSeconds && _model.isOnline) {
          if (mounted) {
            setState(() {
              _model.isOnline = false; 
              
              if (_model.tempLat != null && _model.tempLng != null) {
                _model.lastLocationHistory = 
                    "${_model.tempLat!.toStringAsFixed(5)}, ${_model.tempLng!.toStringAsFixed(5)}";
              }
            });
          }
        }
      }
    });
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
          automaticallyImplyLeading: false,
          title: Text(
            'Status do Rastreador',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Satoshi',
                  color: Colors.black,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
          ),
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(24),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondary,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(blurRadius: 10, color: Colors.blue)],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: _model.isOnline 
                                ? Color(0xFFE0F7FA) 
                                : Color(0xFFFFEBEE), 
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.directions_car_filled,
                            size: 60,
                            color: _model.isOnline 
                                ? Colors.green 
                                : Colors.red,
                          ),
                        ),
                        SizedBox(height: 24),
                        
                        Text(
                          _model.isOnline ? "Rastreador Ligado" : "Rastreador Desligado",
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context).headlineMedium.override(
                                fontFamily: 'Satoshi',
                                color: _model.isOnline ? Colors.green : Colors.red,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(height: 12),
                        
                        Text(
                          "Última comunicação: ${_model.lastSeenText}",
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Satoshi',
                                color: FlutterFlowTheme.of(context).black40,
                                fontSize: 16.0,
                              ),
                        ),
                        SizedBox(height: 16),
                        
                        Divider(),
                        SizedBox(height: 8),

                        // --- ÚLTIMA LOCALIZAÇÃO ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Última localização:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                // COR AMARELA APLICADA AQUI
                                color: Colors.blue, 
                              ),
                            ),
                            Text(
                              _model.isOnline 
                                  ? "Monitorando..." 
                                  : _model.lastLocationHistory,
                              style: TextStyle(
                                color: _model.isOnline ? Colors.blue : Colors.blue
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 8),
                        
                        // --- ID DO DISPOSITIVO ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "ID do Dispositivo:", 
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            Text(
                              "${FFAppState().trackerId}",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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