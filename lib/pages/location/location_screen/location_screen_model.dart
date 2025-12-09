import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'location_screen_widget.dart' show LocationScreenWidget;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLngMap;

class LocationScreenModel extends FlutterFlowModel<LocationScreenWidget> {
  ///  Local state fields for this page.

  // Variável para controlar os painéis (0=Nada, 1=Casa, 2=Posto...)
  int buildrIndex = 0;

  // --- LÓGICA DO RASTREADOR ---
  
  // Controlador para mover a câmera do mapa
  final MapController mapController = MapController();

  // Posição ATUAL (apenas o último ponto)
  latLngMap.LatLng? currentPosition;

  // [NOVO] Histórico do trajeto (Lista de todos os pontos por onde passou)
  List<latLngMap.LatLng> routePoints = [];

  // Status para exibir (opcional)
  String statusText = "Aguardando sinal...";

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    mapController.dispose();
  }
}