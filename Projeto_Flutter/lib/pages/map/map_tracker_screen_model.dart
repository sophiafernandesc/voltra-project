// AQUI ESTÁ A CORREÇÃO: Adicionamos "hide LatLng" para evitar o conflito
import '/flutter_flow/flutter_flow_util.dart' hide LatLng;
import 'map_tracker_screen_widget.dart' show MapTrackerScreenWidget;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; 
import 'package:latlong2/latlong.dart'; 

class MapTrackerScreenModel extends FlutterFlowModel<MapTrackerScreenWidget> {
  ///  State fields for stateful widgets in this page.

  // Controlador para mover a câmera do mapa via código
  final MapController mapController = MapController();

  // Armazena a posição atual recebida do banco de dados
  LatLng? currentPosition;

  // Texto de status
  String statusText = "Conectando ao satélite...";

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    mapController.dispose();
  }
}