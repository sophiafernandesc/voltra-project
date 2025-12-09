import '/flutter_flow/flutter_flow_util.dart';
import '/pages/component/custom_center_appbar/custom_center_appbar_widget.dart';
import '/pages/component/ticket_container/ticket_container_widget.dart';
import 'bookmark_screen_widget.dart' show BookmarkScreenWidget;
import 'package:flutter/material.dart';

class BookmarkScreenModel extends FlutterFlowModel<BookmarkScreenWidget> {
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
