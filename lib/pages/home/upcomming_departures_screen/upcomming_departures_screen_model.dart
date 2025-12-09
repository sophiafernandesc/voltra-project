import '/flutter_flow/flutter_flow_util.dart';
import '/pages/component/custom_center_appbar/custom_center_appbar_widget.dart';
import '/pages/component/ticket_container/ticket_container_widget.dart';
import 'upcomming_departures_screen_widget.dart'
    show UpcommingDeparturesScreenWidget;
import 'package:flutter/material.dart';

class UpcommingDeparturesScreenModel
    extends FlutterFlowModel<UpcommingDeparturesScreenWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for CustomCenterAppbar component.
  late CustomCenterAppbarModel customCenterAppbarModel;
  // Models for TicketContainer dynamic component.
  late FlutterFlowDynamicModels<TicketContainerModel> ticketContainerModels;

  @override
  void initState(BuildContext context) {
    customCenterAppbarModel =
        createModel(context, () => CustomCenterAppbarModel());
    ticketContainerModels =
        FlutterFlowDynamicModels(() => TicketContainerModel());
  }

  @override
  void dispose() {
    customCenterAppbarModel.dispose();
    ticketContainerModels.dispose();
  }
}
