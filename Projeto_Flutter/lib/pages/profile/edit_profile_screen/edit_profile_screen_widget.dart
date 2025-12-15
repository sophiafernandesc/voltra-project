import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

import '/pages/component/custom_center_appbar/custom_center_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'edit_profile_screen_model.dart';
export 'edit_profile_screen_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileScreenWidget extends StatefulWidget {
  const EditProfileScreenWidget({super.key});

  static String routeName = 'EditProfileScreen';
  static String routePath = '/editProfileScreen';

  @override
  State<EditProfileScreenWidget> createState() =>
      _EditProfileScreenWidgetState();
}

class _EditProfileScreenWidgetState extends State<EditProfileScreenWidget> {
  late EditProfileScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditProfileScreenModel());

    // Inicializa com os dados atuais do AppState
    _model.textController1 ??= TextEditingController(text: FFAppState().userFirstName);
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController(text: FFAppState().userLastName);
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController(text: FFAppState().userEmail);
    _model.textFieldFocusNode3 ??= FocusNode();

    // NOVO: Controlador para editar o ID do Rastreador
    _model.textController4 ??= TextEditingController(text: FFAppState().trackerId);
    _model.textFieldFocusNode4 ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              wrapWithModel(
                model: _model.customCenterAppbarModel,
                updateCallback: () => safeSetState(() {}),
                child: CustomCenterAppbarWidget(
                  title: 'Editar perfil',
                  backIcon: false,
                  addIcon: false,
                  onTapAdd: () async {},
                ),
              ),
              Expanded(
                child: Form(
                  key: _model.formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
                    scrollDirection: Axis.vertical,
                    children: [
                      // Imagem de Perfil (código resumido)
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Stack(
                              alignment: AlignmentDirectional(1.0, 1.0),
                              children: [
                                Container(
                                  width: 80.0,
                                  height: 80.0,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(shape: BoxShape.circle),
                                  child: Image.asset('assets/images/prof_defualt.png', fit: BoxFit.contain), 
                                ),
                                // Botão de camera (mantido)
                                InkWell(
                                  child: Container(
                                    width: 40.0,
                                    height: 40.0,
                                    decoration: BoxDecoration(color: FlutterFlowTheme.of(context).secondary, shape: BoxShape.circle),
                                    child: ClipRRect(child: SvgPicture.asset('assets/images/camera_ic.svg', fit: BoxFit.contain)),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${FFAppState().userFirstName} ${FFAppState().userLastName}', style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Satoshi', color: FlutterFlowTheme.of(context).tertiary, fontSize: 18.0, fontWeight: FontWeight.w500)),
                                    Text(FFAppState().userEmail, style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Satoshi', color: FlutterFlowTheme.of(context).tertiary, fontSize: 17.0)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // PRIMEIRO NOME
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20.0, 42.0, 20.0, 24.0),
                        child: TextFormField(
                          controller: _model.textController1,
                          focusNode: _model.textFieldFocusNode1,
                          decoration: InputDecoration(
                            labelText: 'Primeiro nome',
                            labelStyle: FlutterFlowTheme.of(context).labelMedium.override(fontFamily: 'SF Pro Display', color: FlutterFlowTheme.of(context).black40, fontSize: 13.0),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: FlutterFlowTheme.of(context).tertiary, width: 1.0), borderRadius: BorderRadius.circular(12.0)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: FlutterFlowTheme.of(context).tertiary, width: 1.0), borderRadius: BorderRadius.circular(12.0)),
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'SF Pro Display', color: FlutterFlowTheme.of(context).tertiary, fontSize: 17.0),
                          validator: _model.textController1Validator.asValidator(context),
                        ),
                      ),

                      // ÚLTIMO NOME
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 24.0),
                          child: TextFormField(
                            controller: _model.textController2,
                            focusNode: _model.textFieldFocusNode2,
                            decoration: InputDecoration(
                              labelText: 'Último nome',
                              labelStyle: FlutterFlowTheme.of(context).labelMedium.override(fontFamily: 'SF Pro Display', color: FlutterFlowTheme.of(context).black40, fontSize: 13.0),
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: FlutterFlowTheme.of(context).tertiary, width: 1.0), borderRadius: BorderRadius.circular(12.0)),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: FlutterFlowTheme.of(context).tertiary, width: 1.0), borderRadius: BorderRadius.circular(12.0)),
                            ),
                            style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'SF Pro Display', color: FlutterFlowTheme.of(context).tertiary, fontSize: 17.0),
                            validator: _model.textController2Validator.asValidator(context),
                          ),
                        ),
                      ),
                      
                      // NOVO: CAMPO DE EDIÇÃO DO ID DO RASTREADOR
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 24.0),
                          child: TextFormField(
                            controller: _model.textController4,
                            focusNode: _model.textFieldFocusNode4,
                            decoration: InputDecoration(
                              labelText: 'ID do Rastreador',
                              hintText: 'Digite o código do dispositivo',
                              labelStyle: FlutterFlowTheme.of(context).labelMedium.override(fontFamily: 'SF Pro Display', color: FlutterFlowTheme.of(context).black40, fontSize: 13.0),
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: FlutterFlowTheme.of(context).tertiary, width: 1.0), borderRadius: BorderRadius.circular(12.0)),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: FlutterFlowTheme.of(context).tertiary, width: 1.0), borderRadius: BorderRadius.circular(12.0)),
                            ),
                            style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'SF Pro Display', color: FlutterFlowTheme.of(context).tertiary, fontSize: 17.0),
                          ),
                        ),
                      ),

                      // EMAIL
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                          child: TextFormField(
                            controller: _model.textController3,
                            focusNode: _model.textFieldFocusNode3,
                            readOnly: false, 
                            decoration: InputDecoration(
                              hintText: 'Email address',
                              filled: true,
                              fillColor: FlutterFlowTheme.of(context).secondary,
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 1.0), borderRadius: BorderRadius.circular(12.0)),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 1.0), borderRadius: BorderRadius.circular(12.0)),
                            ),
                            style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'SF Pro Display', color: FlutterFlowTheme.of(context).tertiary, fontSize: 17.0),
                            validator: _model.textController3Validator.asValidator(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20.0, 16.0, 20.0, 16.0),
                child: FFButtonWidget(
                  onPressed: () async {
                    if (_model.formKey.currentState == null || !_model.formKey.currentState!.validate()) {
                      return;
                    }

                    String newFirstName = _model.textController1.text;
                    String newLastName = _model.textController2.text;
                    String newEmail = _model.textController3.text;
                    String newTrackerId = _model.textController4.text; // Novo ID

                    try {
                      String uid = FFAppState().userId;

                      await FirebaseFirestore.instance.collection('users').doc(uid).update({
                        'firstName': newFirstName,
                        'lastName': newLastName,
                        'email': newEmail,
                        'trackerId': newTrackerId, // Atualiza o ID no banco
                      });

                      FFAppState().update(() {
                        FFAppState().userFirstName = newFirstName;
                        FFAppState().userLastName = newLastName;
                        FFAppState().userEmail = newEmail;
                        FFAppState().trackerId = newTrackerId; // Atualiza o estado local
                      });

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Perfil atualizado com sucesso!')));
                      context.safePop();

                    } catch (e) {
                      print('Erro ao atualizar: $e');
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao atualizar perfil.')));
                    }
                  },
                  text: 'Salvar',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 56.0,
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(fontFamily: 'Satoshi', color: FlutterFlowTheme.of(context).secondary, fontSize: 18.0, fontWeight: FontWeight.bold),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  showLoadingIndicator: false,
                ),
              ),
            ].addToStart(SizedBox(height: 24.0)),
          ),
        ),
      ),
    );
  }
}