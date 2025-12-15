import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'location_screen_widget.dart' show LocationScreenWidget;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLngMap;

class LocationScreenModel extends FlutterFlowModel<LocationScreenWidget> {
  ///  Local state fields for this page.

  int buildrIndex = 0;

  // --- LÓGICA DO RASTREADOR ---
  
  final MapController mapController = MapController();

  latLngMap.LatLng? currentPosition;

  // Rota completa (Linha azul)
  List<latLngMap.LatLng> routePoints = [];

  // [NOVO] Pontos onde o sinal foi perdido por > 1 minuto (Bolinhas Amarelas)
  List<latLngMap.LatLng> lostSignalPoints = [];

  String statusText = "Aguardando sinal...";

  // Controle do Modo Histórico (Botão)
  bool showHistoryMode = false;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    mapController.dispose();
  }
}