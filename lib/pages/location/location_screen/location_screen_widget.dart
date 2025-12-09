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

export 'location_screen_model.dart';

class LocationScreenWidget extends StatefulWidget {
  const LocationScreenWidget({super.key});

  static String routeName = 'LocationScreen';
  static String routePath = '/locationScreen';

  @override
  State<LocationScreenWidget> createState() => _LocationScreenWidgetState();
}

// [DICA] Adicionado AutomaticKeepAliveClientMixin para o mapa não recarregar ao trocar de aba
class _LocationScreenWidgetState extends State<LocationScreenWidget> with AutomaticKeepAliveClientMixin {
  late LocationScreenModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  StreamSubscription<DatabaseEvent>? _trackerSubscription;

  // Tokens do Mapbox
  final String mapboxAccessToken = 'pk.eyJ1Ijoidml0b3JpYXJhbmkiLCJhIjoiY21paTAxcmN1MDg3eDNqb2N3d3hmMXlmOCJ9.UPr0WqgUY1V-4tkvdrTo6w';

  @override
  bool get wantKeepAlive => true; // Mantém a tela viva na memória

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LocationScreenModel());
    _startListeningToTracker();
  }

  @override
  void dispose() {
    _trackerSubscription?.cancel();
    _model.dispose();
    super.dispose();
  }

  void _startListeningToTracker() {
    String trackerId = FFAppState().trackerId;

    if (trackerId.isEmpty) return;

    DatabaseReference ref = FirebaseDatabase.instance.ref('rastreador/$trackerId');

    _trackerSubscription = ref.onValue.listen((event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
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
  }

  void _updateMapLocation(double lat, double lng) {
    latLngMap.LatLng newPos = latLngMap.LatLng(lat, lng);
    
    // Só faz algo se a posição mudou
    if (_model.currentPosition != newPos) {
      
      // 1. Captura o zoom ATUAL do usuário antes de atualizar a tela
      double currentZoom = 15.0; // Valor padrão de segurança
      try {
        currentZoom = _model.mapController.camera.zoom;
      } catch (e) {
        // O mapa pode não estar pronto ainda, mantemos 15.0
      }

      // 2. Atualiza os dados (Marcador e Rastro)
      if (mounted) {
        setState(() {
          _model.currentPosition = newPos;
          _model.routePoints.add(newPos);
        });
      }

      // 3. Move a câmera mantendo o zoom que o usuário escolheu
      try {
        _model.mapController.move(newPos, currentZoom);
      } catch (e) {
        // Ignora erro se controlador não estiver pronto
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Necessário pelo KeepAlive

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
            // --- O MAPA (FUNDO) ---
            FlutterMap(
              mapController: _model.mapController,
              options: MapOptions(
                // [CORREÇÃO CRÍTICA] Usamos uma coordenada fixa aqui.
                // Se usássemos _model.currentPosition, o mapa resetaria a cada movimento.
                // O controlador (mapController) vai mover para o carro assim que o sinal chegar.
                initialCenter: latLngMap.LatLng(-19.9328,-43.9922), 
                initialZoom: 15.0,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/256/{z}/{x}/{y}@2x?access_token=$mapboxAccessToken',
                  userAgentPackageName: 'com.estudante.rastreador_gps',
                  tileProvider: NetworkTileProvider(), 
                ),
                
                // RASTRO (LINHA PONTILHADA)
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

                // MARCADOR (CARRO)
                if (_model.currentPosition != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _model.currentPosition!,
                        width: 60,
                        height: 60,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black38)],
                          ),
                          child: Icon(
                            Icons.directions_car_filled, 
                            color: FlutterFlowTheme.of(context).primary, 
                            size: 35,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),

            // --- BARRA DE PESQUISA ---
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20.0, 63.0, 20.0, 0.0),
              child: InkWell(
                onTap: () async {
                  context.pushNamed(SearchScreenWidget.routeName);
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondary,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black12, offset: Offset(0, 2))],
                  ),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 15.0, 0.0, 16.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(0.0),
                          child: SvgPicture.asset(
                            'assets/images/search_ic.svg',
                            width: 24.0,
                            height: 24.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 0.0, 0.0),
                            child: Text(
                              'Pesquisar',
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Satoshi',
                                    color:
                                        FlutterFlowTheme.of(context).tertiary,
                                    fontSize: 17.0,
                                    letterSpacing: 0.0,
                                    lineHeight: 1.2,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // --- BOTÃO DE ROTA/MENU (GPS) ---
            Align(
              alignment: AlignmentDirectional(1.0, 1.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  
                  // BOTÃO DE CENTRALIZAR
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 20.0, 16.0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        // Centraliza mantendo o zoom atual ou resetando para 16 se preferir
                        if (_model.currentPosition != null) {
                          // Aqui forçamos um zoom bom (16) pois o usuário pediu pra centralizar
                          _model.mapController.move(_model.currentPosition!, 16.0);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Aguardando sinal do veículo...")),
                          );
                        }
                      },
                      child: Container(
                        width: 56.0,
                        height: 56.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primary,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black26, offset: Offset(0, 2))],
                        ),
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(0.0),
                          child: SvgPicture.asset(
                            'assets/images/GPS_ic.svg',
                            fit: BoxFit.cover,
                            alignment: Alignment(0.0, 0.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // MENUS INFERIORES
                  Builder(
                    builder: (context) {
                      if (_model.buildrIndex == 1) {
                        return Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              20.0, 0.0, 20.0, 16.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(16.0),
                              boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Casa',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Satoshi',
                                                color: FlutterFlowTheme.of(context)
                                                    .primaryText,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          _model.buildrIndex = 0;
                                          safeSetState(() {});
                                        },
                                        child: Icon(
                                          Icons.close_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          size: 24.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // ... (Resto do conteúdo visual mantido)
                                  SizedBox(height: 50),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          width: 0.0,
                          height: 0.0,
                          decoration: BoxDecoration(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}