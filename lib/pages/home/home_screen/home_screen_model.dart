import '/flutter_flow/flutter_flow_util.dart';
import '/pages/component/ticket_container/ticket_container_widget.dart';
import '/index.dart';
import 'home_screen_widget.dart' show HomeScreenWidget;
import 'package:flutter/material.dart';

class HomeScreenModel extends FlutterFlowModel<HomeScreenWidget> {
  ///  Local state fields for this page.

  int selectindex = 0;

  int buildrIndex = 0;

  // currently selected car name for the top capsule dropdown
  String? selectedCar;

  ///  State fields for stateful widgets in this page.

  // Models for TicketContainer dynamic component.
  late FlutterFlowDynamicModels<TicketContainerModel> ticketContainerModels;
  

  @override
  void initState(BuildContext context) {
    ticketContainerModels =
        FlutterFlowDynamicModels(() => TicketContainerModel());
  }

  @override
  void dispose() {
    ticketContainerModels.dispose();
  }
}
