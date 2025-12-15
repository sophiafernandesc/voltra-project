import '/flutter_flow/flutter_flow_util.dart';
import 'edit_profile_screen_widget.dart' show EditProfileScreenWidget;
import 'package:flutter/material.dart';

// [IMPORTANTE] Importar o model do componente de AppBar
// Se der erro de caminho, verifique se o arquivo existe em /pages/component/...
import '/pages/component/custom_center_appbar/custom_center_appbar_widget.dart'; 
// Nota: Em alguns projetos FlutterFlow, o Model pode estar em um arquivo separado como 'custom_center_appbar_model.dart'.
// Se o import acima não trouxer o 'CustomCenterAppbarModel', tente:
// import '/pages/component/custom_center_appbar/custom_center_appbar_model.dart';

class EditProfileScreenModel extends FlutterFlowModel<EditProfileScreenWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();

  // --- [NOVO] Model do Componente AppBar ---
  // Isso resolve o erro "getter customCenterAppbarModel isn't defined"
  late CustomCenterAppbarModel customCenterAppbarModel;

  // Controle de Upload de Imagem
  bool isDataUploading_uploadData3zd = false;
  FFUploadedFile uploadedLocalFile_uploadData3zd =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  // --- Campos de Texto ---

  // Primeiro Nome
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;

  // Último Nome
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;

  // Email
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;

  // ID do Rastreador
  FocusNode? textFieldFocusNode4;
  TextEditingController? textController4;
  String? Function(BuildContext, String?)? textController4Validator;

  /// Inicialização
  @override
  void initState(BuildContext context) {
    // [NOVO] Inicializa o model do AppBar
    customCenterAppbarModel = createModel(context, () => CustomCenterAppbarModel());
  }

  /// Limpeza de memória
  @override
  void dispose() {
    // [NOVO] Descarta o model do AppBar
    customCenterAppbarModel.dispose();

    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();

    textFieldFocusNode4?.dispose();
    textController4?.dispose();
  }
}