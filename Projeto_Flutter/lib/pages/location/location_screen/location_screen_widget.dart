import 'dart:async';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import '/app_state.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'location_screen_model.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLngMap;
import 'package:firebase_database/firebase_database.dart'; 
import '/secrets.dart'; // Cofre de chaves

export 'location_screen_model.dart';

class LocationScreenWidget extends StatefulWidget {
  const LocationScreenWidget({super.key});

  static String routeName = 'LocationScreen';
  static String routePath = '/locationScreen';

  @override
  State<LocationScreenWidget> createState() => _LocationScreenWidgetState();
}

class _LocationScreenWidgetState extends State<LocationScreenWidget> with AutomaticKeepAliveClientMixin {
  late LocationScreenModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  StreamSubscription<DatabaseEvent>? _trackerSubscription;
  Timer? _offlineTimer;
  DateTime? _lastSignalTime;
  bool _isOnline = false; 
  
  //Tempo limite para considerar offline (em segundos)
  final int _timeoutSeconds = 60; 

  final Color yellowCustom = const Color.fromARGB(255, 250, 192, 17);

  @override
  bool get wantKeepAlive => true; 

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LocationScreenModel());
    _startListeningToTracker();
  }

  @override
  void dispose() {
    _trackerSubscription?.cancel();
    _offlineTimer?.cancel();
    _model.dispose();
    super.dispose();
  }

  void _startListeningToTracker() {
    String trackerId = FFAppState().trackerId;
    if (trackerId.isEmpty) return;

    DatabaseReference ref = FirebaseDatabase.instance.ref('rastreador/$trackerId');

    _trackerSubscription = ref.onValue.listen((event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        _lastSignalTime = DateTime.now();
        
        if (!_isOnline) {
           if (mounted) setState(() => _isOnline = true);
        }

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
      }
    });

    _offlineTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (_lastSignalTime != null) {
        final timeDiff = DateTime.now().difference(_lastSignalTime!).inSeconds;
        
        // [ALTERAÇÃO 2] Se passou de 1 minuto sem sinal...
        if (timeDiff > _timeoutSeconds && _isOnline) {
          if (mounted) {
            setState(() {
              _isOnline = false; // Marca offline (carro vermelho)
              
              // SALVA O PONTO ONDE CAIU O SINAL
              if (_model.currentPosition != null) {
                // Evita adicionar duplicados se o timer rodar de novo
                if (!_model.lostSignalPoints.contains(_model.currentPosition!)) {
                   _model.lostSignalPoints.add(_model.currentPosition!);
                }
              }
            });
          }
        }
      }
    });
  }

  void _updateMapLocation(double lat, double lng) {
    latLngMap.LatLng newPos = latLngMap.LatLng(lat, lng);
    
    if (_model.currentPosition != newPos) {
      double currentZoom = 15.0;
      try {
        currentZoom = _model.mapController.camera.zoom;
      } catch (e) {}

      if (mounted) {
        setState(() {
          _model.currentPosition = newPos;
          _model.routePoints.add(newPos);
        });
      }

      if (!_model.showHistoryMode) {
        try {
          _model.mapController.move(newPos, currentZoom);
        } catch (e) {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Stack(
          children: [
            // --- O MAPA ---
            FlutterMap(
              mapController: _model.mapController,
              options: MapOptions(
                initialCenter: latLngMap.LatLng(-19.9328,-43.9922), 
                initialZoom: 15.0,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/256/{z}/{x}/{y}@2x?access_token=$kMapboxAccessToken',
                  userAgentPackageName: 'com.estudante.rastreador_gps',
                  tileProvider: NetworkTileProvider(), 
                ),
                
                // RASTRO (Linha Azul)
                if (_model.routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _model.routePoints,
                        strokeWidth: 5.0,
                        color: Colors.blueAccent,
                        borderColor: Colors.blue[800]!, 
                        borderStrokeWidth: 1.0,
                        isDotted: true,
                      ),
                    ],
                  ),

                // [NOVO] CAMADA DE PERDA DE SINAL AUTOMÁTICA
                // Bolinhas amarelas que aparecem quando fica > 1 min offline
                if (_model.lostSignalPoints.isNotEmpty)
                  MarkerLayer(
                    markers: _model.lostSignalPoints.map((point) {
                      return Marker(
                        point: point,
                        width: 20,
                        height: 20,
                        child: Container(
                          decoration: BoxDecoration(
                            color: yellowCustom, // Amarelo
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.red, width: 2), // Borda vermelha para destaque
                            boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black45)],
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                // CAMADA DE HISTÓRICO MANUAL (Botão Esquerdo)
                if (_model.showHistoryMode && _model.routePoints.isNotEmpty)
                  MarkerLayer(
                    markers: _model.routePoints.asMap().entries.map((entry) {
                      int idx = entry.key;
                      latLngMap.LatLng point = entry.value;
                      bool isLastPoint = idx == _model.routePoints.length - 1;

                      // Não desenha em cima dos pontos de perda de sinal para não poluir
                      if (_model.lostSignalPoints.contains(point)) return null;

                      return Marker(
                        point: point,
                        width: isLastPoint ? 40 : 15,
                        height: isLastPoint ? 40 : 15,
                        child: isLastPoint
                            ? Icon(Icons.location_on, color: Colors.red, size: 40)
                            : Container(
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 252, 192, 12), // Amarelo
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black54, width: 1),
                                ),
                              ),
                      );
                    }).whereType<Marker>().toList(), // Remove os nulos
                  ),

                // MARCADOR DO CARRO (Tempo Real)
                if (_model.currentPosition != null && !_model.showHistoryMode)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _model.currentPosition!,
                        width: 70, 
                        height: 70,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black38)],
                            border: Border.all(
                              color: _isOnline ? Colors.green : Colors.red,
                              width: 3.0,
                            ),
                          ),
                          child: Icon(
                            Icons.directions_car_filled, 
                            color: _isOnline ? Colors.green : Colors.red,
                            size: 35,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),

            // --- BARRA DE PESQUISA (REMOVIDA) ---

            // --- BOTÕES INFERIORES ---
            // Lado Direito (GPS)
            Align(
              alignment: AlignmentDirectional(1.0, 1.0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 20.0, 16.0),
                child: InkWell(
                  onTap: () async {
                    if (_model.currentPosition != null) {
                      _model.mapController.move(_model.currentPosition!, 16.0);
                    }
                  },
                  child: Container(
                    width: 56.0,
                    height: 56.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primary,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black26)],
                    ),
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0.0),
                      child: SvgPicture.asset(
                        'assets/images/GPS_ic.svg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Lado Esquerdo (Histórico Manual)
            Align(
              alignment: AlignmentDirectional(-1.0, 1.0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 0.0, 16.0),
                child: InkWell(
                  onTap: () async {
                    setState(() {
                      _model.showHistoryMode = !_model.showHistoryMode;
                    });
                  },
                  child: Container(
                    width: 56.0,
                    height: 56.0,
                    decoration: BoxDecoration(
                      color: _model.showHistoryMode ? yellowCustom : Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black26)],
                    ),
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Icon(
                      Icons.history,
                      color: _model.showHistoryMode ? Colors.black : Colors.black87,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}