import '/flutter_flow/flutter_flow_util.dart';
import 'login_screen_widget.dart' show LoginScreenWidget;
import 'package:flutter/material.dart';

class LoginScreenModel extends FlutterFlowModel<LoginScreenWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  
  // Controlador das Abas (Entrar / Cadastrar)
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // Chaves dos Formulários (para validação)
  final formKey1 = GlobalKey<FormState>(); // Form Entrar
  final formKey2 = GlobalKey<FormState>(); // Form Cadastrar

  // -------------------------
  // CAMPOS DA ABA: ENTRAR
  // -------------------------
  
  // Campo Email (Login)
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;

  // Campo Senha (Login)
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  late bool passwordVisibility1;
  String? Function(BuildContext, String?)? textController2Validator;

  // -------------------------
  // CAMPOS DA ABA: CADASTRAR
  // -------------------------

  // Campo Primeiro Nome
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;

  // Campo Último Nome
  FocusNode? textFieldFocusNode4;
  TextEditingController? textController4;
  String? Function(BuildContext, String?)? textController4Validator;

  // Campo Email (Cadastro)
  FocusNode? textFieldFocusNode5;
  TextEditingController? textController5;
  String? Function(BuildContext, String?)? textController5Validator;

  // Campo Senha (Cadastro)
  FocusNode? textFieldFocusNode6;
  TextEditingController? textController6;
  late bool passwordVisibility2;
  String? Function(BuildContext, String?)? textController6Validator;

  // -------------------------
  // [NOVO] CAMPO ID DO RASTREADOR
  // -------------------------
  // Isso é o que estava faltando e causando o erro!
  FocusNode? textFieldFocusNode7;
  TextEditingController? textController7;
  String? Function(BuildContext, String?)? textController7Validator;

  /// Inicialização
  @override
  void initState(BuildContext context) {
    passwordVisibility1 = false;
    passwordVisibility2 = false;
  }

  /// Limpeza de memória
  @override
  void dispose() {
    unfocusNode.dispose();
    tabBarController?.dispose();

    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();

    textFieldFocusNode4?.dispose();
    textController4?.dispose();

    textFieldFocusNode5?.dispose();
    textController5?.dispose();

    textFieldFocusNode6?.dispose();
    textController6?.dispose();

    // Limpar o novo controlador também
    textFieldFocusNode7?.dispose();
    textController7?.dispose();
  }
}