import '/flutter_flow/flutter_flow_util.dart';
import 'tracker_info_screen_widget.dart' show TrackerInfoScreenWidget;
import 'package:flutter/material.dart';

class TrackerInfoScreenModel extends FlutterFlowModel<TrackerInfoScreenWidget> {
  /// Variáveis de Estado
  
  // Indica se o rastreador está ligado
  bool isOnline = false;

  // Texto com a hora do último sinal
  String lastSeenText = "Aguardando sinal...";

  // --- NOVAS VARIÁVEIS ---
  
  // Guarda as coordenadas temporariamente enquanto está ligado
  double? tempLat;
  double? tempLng;

  // Guarda o texto final para exibir SÓ quando desligar
  String lastLocationHistory = "Nenhuma registrada";

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}