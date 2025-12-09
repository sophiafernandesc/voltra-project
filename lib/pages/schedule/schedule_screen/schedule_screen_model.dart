import '/flutter_flow/flutter_flow_calendar.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/component/custom_center_appbar/custom_center_appbar_widget.dart';
import '/pages/component/ticket_container/ticket_container_widget.dart';
import 'schedule_screen_widget.dart' show ScheduleScreenWidget;
import 'package:flutter/material.dart';

class ScheduleScreenModel extends FlutterFlowModel<ScheduleScreenWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for CustomCenterAppbar component.
  late CustomCenterAppbarModel customCenterAppbarModel;
  // State field(s) for Calendar widget.
  DateTimeRange? calendarSelectedDay;
  // Models for TicketContainer dynamic component.
  late FlutterFlowDynamicModels<TicketContainerModel> ticketContainerModels;

  @override
  void initState(BuildContext context) {
    customCenterAppbarModel =
        createModel(context, () => CustomCenterAppbarModel());
    calendarSelectedDay = DateTimeRange(
      start: DateTime.now().startOfDay,
      end: DateTime.now().endOfDay,
    );
    ticketContainerModels =
        FlutterFlowDynamicModels(() => TicketContainerModel());
  }

  @override
  void dispose() {
    customCenterAppbarModel.dispose();
    ticketContainerModels.dispose();
  }
}
