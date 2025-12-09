import '/flutter_flow/flutter_flow_util.dart';
import '/pages/component/custom_center_appbar/custom_center_appbar_widget.dart';
import 'security_screen_widget.dart' show SecurityScreenWidget;
import 'package:flutter/material.dart';

class SecurityScreenModel extends FlutterFlowModel<SecurityScreenWidget> {
  ///  Local state fields for this page.

  bool faceSelect = true;

  bool notificationSelect = false;

  ///  State fields for stateful widgets in this page.

  // Model for CustomCenterAppbar component.
  late CustomCenterAppbarModel customCenterAppbarModel;

  @override
  void initState(BuildContext context) {
    customCenterAppbarModel =
        createModel(context, () => CustomCenterAppbarModel());
  }

  @override
  void dispose() {
    customCenterAppbarModel.dispose();
  }
}
