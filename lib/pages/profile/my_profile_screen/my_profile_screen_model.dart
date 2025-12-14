import '/flutter_flow/flutter_flow_util.dart';
import '/pages/component/custom_center_appbar/custom_center_appbar_widget.dart';
import '/index.dart';
import 'my_profile_screen_widget.dart' show MyProfileScreenWidget;
import 'package:flutter/material.dart';

class MyProfileScreenModel extends FlutterFlowModel<MyProfileScreenWidget> {
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
