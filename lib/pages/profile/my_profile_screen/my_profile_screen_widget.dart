import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/component/custom_center_appbar/custom_center_appbar_widget.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'my_profile_screen_model.dart';
export 'my_profile_screen_model.dart';
import '/app_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

class MyProfileScreenWidget extends StatefulWidget {
  const MyProfileScreenWidget({super.key});

  static String routeName = 'MyProfileScreen';
  static String routePath = '/myProfileScreen';

  @override
  State<MyProfileScreenWidget> createState() => _MyProfileScreenWidgetState();
}

class _MyProfileScreenWidgetState extends State<MyProfileScreenWidget> {
  late MyProfileScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MyProfileScreenModel());
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
                  title: 'Meu perfil',
                  backIcon: false,
                  addIcon: true,
                  onTapAdd: () async {
                    context.pushNamed(EditProfileScreenWidget.routeName);
                  },
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(0, 16.0, 0, 0),
                  scrollDirection: Axis.vertical,
                  children: [
                    // CABEÇALHO
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 32.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: 80.0,
                            height: 80.0,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: Image.asset('assets/images/prof_defualt.png', fit: BoxFit.contain),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${FFAppState().userFirstName} ${FFAppState().userLastName}',
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Satoshi', color: FlutterFlowTheme.of(context).tertiary, fontSize: 18.0, fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    FFAppState().userEmail,
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Satoshi', color: FlutterFlowTheme.of(context).tertiary, fontSize: 17.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // CAMPO ID DO RASTREADOR
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 16.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondary,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: FlutterFlowTheme.of(context).primary.withOpacity(0.2)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.gps_fixed, size: 16, color: FlutterFlowTheme.of(context).primary),
                                  SizedBox(width: 8),
                                  Text(
                                    'ID do Rastreador',
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Satoshi', color: FlutterFlowTheme.of(context).tertiary, fontSize: 18.0, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Text(
                                FFAppState().trackerId.isNotEmpty ? FFAppState().trackerId : 'Nenhum rastreador vinculado',
                                maxLines: 1,
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Satoshi', 
                                  color: FFAppState().trackerId.isNotEmpty ? FlutterFlowTheme.of(context).black40 : FlutterFlowTheme.of(context).error,
                                  fontSize: 17.0,
                                ),
                              ),
                            ].divide(SizedBox(height: 6.0)),
                          ),
                        ),
                      ),
                    ),

                    // CAMPO PRIMEIRO NOME
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 16.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(color: FlutterFlowTheme.of(context).secondary, borderRadius: BorderRadius.circular(12.0)),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Primeiro Nome', style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Satoshi', color: FlutterFlowTheme.of(context).tertiary, fontSize: 18.0, fontWeight: FontWeight.w500)),
                              Text(FFAppState().userFirstName, maxLines: 1, style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Satoshi', color: FlutterFlowTheme.of(context).black40, fontSize: 17.0)),
                            ].divide(SizedBox(height: 6.0)),
                          ),
                        ),
                      ),
                    ),

                    // CAMPO ÚLTIMO NOME
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 16.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(color: FlutterFlowTheme.of(context).secondary, borderRadius: BorderRadius.circular(12.0)),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Último Nome', style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Satoshi', color: FlutterFlowTheme.of(context).tertiary, fontSize: 18.0, fontWeight: FontWeight.w500)),
                              Text(FFAppState().userLastName, maxLines: 1, style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Satoshi', color: FlutterFlowTheme.of(context).black40, fontSize: 17.0)),
                            ].divide(SizedBox(height: 6.0)),
                          ),
                        ),
                      ),
                    ),

                    // CAMPO EMAIL
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 16.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(color: FlutterFlowTheme.of(context).secondary, borderRadius: BorderRadius.circular(12.0)),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Email', style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Satoshi', color: FlutterFlowTheme.of(context).tertiary, fontSize: 18.0, fontWeight: FontWeight.w500)),
                              Text(FFAppState().userEmail, maxLines: 1, style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Satoshi', color: FlutterFlowTheme.of(context).black40, fontSize: 17.0)),
                            ].divide(SizedBox(height: 6.0)),
                          ),
                        ),
                      ),
                    ),

                    // BOTÃO DE DELETAR CONTA
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20.0, 32.0, 20.0, 32.0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          bool? confirmed = await showDialog<bool>(
                            context: context,
                            builder: (alertDialogContext) {
                              return AlertDialog(
                                title: Text('Deletar Conta'),
                                content: Text('Tem certeza? Isso apagará todos os seus dados permanentemente, incluindo o vínculo com o rastreador.'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(alertDialogContext, false), child: Text('Cancelar')),
                                  TextButton(onPressed: () => Navigator.pop(alertDialogContext, true), child: Text('Sim, Deletar', style: TextStyle(color: Colors.red))),
                                ],
                              );
                            },
                          );

                          if (confirmed == null || !confirmed) return;

                          try {
                            User? user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              // Deleta o documento do Firestore (inclui o campo trackerId)
                              await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
                              await user.delete();

                              if (!context.mounted) return;

                              FFAppState().update(() {
                                FFAppState().userFirstName = '';
                                FFAppState().userLastName = '';
                                FFAppState().userEmail = '';
                                FFAppState().trackerId = '';
                                FFAppState().userId = '';
                                FFAppState().isLogin = false;
                              });

                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Conta deletada com sucesso.')));
                              context.goNamed(LoginScreenWidget.routeName);
                            }
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'requires-recent-login') {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Por segurança, faça Logout e entre novamente para deletar a conta.')));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
                            }
                          }
                        },
                        text: 'Deletar Conta',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 56.0,
                          color: FlutterFlowTheme.of(context).error,
                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(fontFamily: 'Satoshi', color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                          elevation: 0.0,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        showLoadingIndicator: false,
                      ),
                    ),
                  ],
                ),
              ),
            ].addToStart(SizedBox(height: 24.0)),
          ),
        ),
      ),
    );
  }
}