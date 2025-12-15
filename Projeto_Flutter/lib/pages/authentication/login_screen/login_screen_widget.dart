import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'login_screen_model.dart';
export 'login_screen_model.dart';

class LoginScreenWidget extends StatefulWidget {
  const LoginScreenWidget({super.key});

  static String routeName = 'LoginScreen';
  static String routePath = '/loginScreen';

  @override
  State<LoginScreenWidget> createState() => _LoginScreenWidgetState();
}

class _LoginScreenWidgetState extends State<LoginScreenWidget>
    with TickerProviderStateMixin {
  late LoginScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginScreenModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    // --- Controladores da Aba LOGIN ---
    _model.textController1 ??= TextEditingController(); // Email Login
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController(); // Senha Login
    _model.textFieldFocusNode2 ??= FocusNode();

    // --- Controladores da Aba CADASTRO ---
    _model.textController3 ??= TextEditingController(); // Primeiro Nome
    _model.textFieldFocusNode3 ??= FocusNode();

    _model.textController4 ??= TextEditingController(); // Último Nome
    _model.textFieldFocusNode4 ??= FocusNode();

    _model.textController5 ??= TextEditingController(); // Email Cadastro
    _model.textFieldFocusNode5 ??= FocusNode();

    _model.textController6 ??= TextEditingController(); // Senha Cadastro
    _model.textFieldFocusNode6 ??= FocusNode();

    // [NOVO] Controlador para o ID do Rastreador
    _model.textController7 ??= TextEditingController(); 
    _model.textFieldFocusNode7 ??= FocusNode();
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
        backgroundColor: FlutterFlowTheme.of(context).primaryText,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // --- CABEÇALHO (Logo e Título) ---
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'assets/images/ChatGPT_Image_25_de_set._de_2025,_10_30_19.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    'Voltra',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Satoshi',
                          color: FlutterFlowTheme.of(context).tertiary,
                          fontSize: 24.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                          lineHeight: 1.5,
                        ),
                  ),
                ]
                    .divide(SizedBox(height: 8.0))
                    .addToStart(SizedBox(height: 32.0))
                    .addToEnd(SizedBox(height: 32.0)),
              ),
              
              Flexible(
                child: Column(
                  children: [
                    // --- MENU DE ABAS (Entrar / Cadastrar) ---
                    Align(
                      alignment: Alignment(0.0, 0),
                      child: TabBar(
                        labelColor: FlutterFlowTheme.of(context).primary,
                        unselectedLabelColor:
                            FlutterFlowTheme.of(context).tertiary,
                        labelPadding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 20.0, 0.0),
                        labelStyle:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  fontFamily: 'Satoshi',
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                ),
                        unselectedLabelStyle:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  fontFamily: 'Satoshi',
                                  fontSize: 17.0,
                                  letterSpacing: 0.0,
                                ),
                        indicatorColor: FlutterFlowTheme.of(context).primary,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 20.0, 0.0),
                        tabs: [
                          Tab(text: 'Entrar'),
                          Tab(text: 'Cadastrar'),
                        ],
                        controller: _model.tabBarController,
                        onTap: (i) async {
                          [() async {}, () async {}][i]();
                        },
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _model.tabBarController,
                        children: [
                          // ==================================================
                          // ABA 1: LOGIN (ENTRAR)
                          // ==================================================
                          Form(
                            key: _model.formKey1,
                            autovalidateMode: AutovalidateMode.disabled,
                            child: ListView(
                              padding: EdgeInsets.fromLTRB(0, 32.0, 0, 0),
                              scrollDirection: Axis.vertical,
                              children: [
                                // Campo Email (Login)
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      20.0, 0.0, 20.0, 0.0),
                                  child: TextFormField(
                                    controller: _model.textController1,
                                    focusNode: _model.textFieldFocusNode1,
                                    autofocus: false,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      labelStyle: FlutterFlowTheme.of(context).labelMedium.override(fontFamily: 'SF Pro Display', color: FlutterFlowTheme.of(context).black40, fontSize: 13.0),
                                      hintText: 'Digite seu email',
                                      hintStyle: FlutterFlowTheme.of(context).labelMedium.override(fontFamily: 'Satoshi', color: FlutterFlowTheme.of(context).black40, fontSize: 17.0),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: FlutterFlowTheme.of(context).tertiary, width: 1.0), borderRadius: BorderRadius.circular(12.0)),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: FlutterFlowTheme.of(context).tertiary, width: 1.0), borderRadius: BorderRadius.circular(12.0)),
                                      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: FlutterFlowTheme.of(context).error, width: 1.0), borderRadius: BorderRadius.circular(12.0)),
                                      focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: FlutterFlowTheme.of(context).error, width: 1.0), borderRadius: BorderRadius.circular(12.0)),
                                      contentPadding: EdgeInsetsDirectional.fromSTEB(16.0, 13.0, 0.0, 12.0),
                                    ),
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'SF Pro Display', color: FlutterFlowTheme.of(context).tertiary, fontSize: 17.0),
                                    cursorColor: FlutterFlowTheme.of(context).primary,
                                    validator: _model.textController1Validator.asValidator(context),
                                  ),
                                ),
                                // Campo Senha (Login)
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      20.0, 8.0, 20.0, 0.0),
                                  child: TextFormField(
                                    controller: _model.textController2,
                                    focusNode: _model.textFieldFocusNode2,
                                    autofocus: false,
                                    textInputAction: TextInputAction.done,
                                    obscureText: !_model.passwordVisibility1,
                                    decoration: InputDecoration(
                                      labelText: 'Senha',
                                      labelStyle: FlutterFlowTheme.of(context).labelMedium.override(fontFamily: 'SF Pro Display', color: FlutterFlowTheme.of(context).black40, fontSize: 13.0),
                                      hintText: 'Digite sua senha',
                                      hintStyle: FlutterFlowTheme.of(context).labelMedium.override(fontFamily: 'Satoshi', color: FlutterFlowTheme.of(context).black40, fontSize: 17.0),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: FlutterFlowTheme.of(context).tertiary, width: 1.0), borderRadius: BorderRadius.circular(12.0)),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: FlutterFlowTheme.of(context).tertiary, width: 1.0), borderRadius: BorderRadius.circular(12.0)),
                                      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: FlutterFlowTheme.of(context).error, width: 1.0), borderRadius: BorderRadius.circular(12.0)),
                                      focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: FlutterFlowTheme.of(context).error, width: 1.0), borderRadius: BorderRadius.circular(12.0)),
                                      contentPadding: EdgeInsetsDirectional.fromSTEB(16.0, 13.0, 0.0, 12.0),
                                      suffixIcon: InkWell(
                                        onTap: () => safeSetState(() => _model.passwordVisibility1 = !_model.passwordVisibility1),
                                        focusNode: FocusNode(skipTraversal: true),
                                        child: Icon(
                                          _model.passwordVisibility1 ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                          color: FlutterFlowTheme.of(context).black40,
                                          size: 24.0,
                                        ),
                                      ),
                                    ),
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'SF Pro Display', color: FlutterFlowTheme.of(context).tertiary, fontSize: 17.0),
                                    cursorColor: FlutterFlowTheme.of(context).primary,
                                    validator: _model.textController2Validator.asValidator(context),
                                  ),
                                ),
                                // Botão ENTRAR
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      20.0, 32.0, 20.0, 0.0),
                                  child: FFButtonWidget(
                                    onPressed: () async {
                                      if (_model.formKey1.currentState == null || !_model.formKey1.currentState!.validate()) {
                                        return;
                                      }
                                      String email = _model.textController1.text.trim();
                                      String password = _model.textController2.text;

                                      try {
                                        // 1. Faz Login no Firebase
                                        UserCredential userCredential = await FirebaseAuth.instance
                                            .signInWithEmailAndPassword(email: email, password: password);
                                        String uid = userCredential.user!.uid;

                                        // 2. Busca dados extras (Nome, TrackerId) no Firestore
                                        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

                                        if (userDoc.exists) {
                                          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
                                          
                                          // 3. Atualiza o estado global do App
                                          FFAppState().update(() {
                                            FFAppState().userFirstName = data['firstName'] ?? '';
                                            FFAppState().userLastName = data['lastName'] ?? '';
                                            FFAppState().userEmail = data['email'] ?? '';
                                            // [IMPORTANTE] Carrega o ID do Rastreador para a memória
                                            FFAppState().trackerId = data['trackerId'] ?? ''; 
                                            FFAppState().userId = uid;
                                            FFAppState().isLogin = true;
                                          });

                                          context.goNamed(HomeScreenWidget.routeName);
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: Usuário sem dados no banco.')));
                                        }
                                      } on FirebaseAuthException catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao entrar: ${e.message}')));
                                      }
                                    },
                                    text: 'Entrar',
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
                              ].divide(SizedBox(height: 16.0)),
                            ),
                          ),
                          
                          // ==================================================
                          // ABA 2: CADASTRAR
                          // ==================================================
                          Form(
                            key: _model.formKey2,
                            autovalidateMode: AutovalidateMode.disabled,
                            child: ListView(
                              padding: EdgeInsets.fromLTRB(0, 32.0, 0, 0),
                              scrollDirection: Axis.vertical,
                              children: [
                                // Nome
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      20.0, 0.0, 20.0, 0.0),
                                  child: TextFormField(
                                    controller: _model.textController3, 
                                    focusNode: _model.textFieldFocusNode3,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      labelText: 'Primeiro nome',
                                      labelStyle: FlutterFlowTheme.of(context).labelMedium.override(fontFamily: 'SF Pro Display', color: Color(0xFFA3A3A3), fontSize: 13.0),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: FlutterFlowTheme.of(context).tertiary, width: 1.0), borderRadius: BorderRadius.circular(12.0)),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: FlutterFlowTheme.of(context).tertiary, width: 1.0), borderRadius: BorderRadius.circular(12.0)),
                                      contentPadding: EdgeInsetsDirectional.fromSTEB(16.0, 13.0, 0.0, 12.0),
                                    ),
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'SF Pro Display', color: FlutterFlowTheme.of(context).tertiary, fontSize: 17.0),
                                    cursorColor: FlutterFlowTheme.of(context).primary,
                                    validator: _model.textController3Validator.asValidator(context),
                                  ),
                                ),
                                // Sobrenome
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      20.0, 0.0, 20.0, 0.0),
                                  child: TextFormField(
                                    controller: _model.textController4, 
                                    focusNode: _model.textFieldFocusNode4,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      labelText: 'Último nome',
                                      labelStyle: FlutterFlowTheme.of(context).labelMedium.override(fontFamily: 'SF Pro Display', color: FlutterFlowTheme.of(context).black40, fontSize: 13.0),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: FlutterFlowTheme.of(context).tertiary, width: 1.0), borderRadius: BorderRadius.circular(12.0)),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: FlutterFlowTheme.of(context).tertiary, width: 1.0), borderRadius: BorderRadius.circular(12.0)),
                                      contentPadding: EdgeInsetsDirectional.fromSTEB(16.0, 13.0, 0.0, 12.0),
                                    ),
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'SF Pro Display', color: FlutterFlowTheme.of(context).tertiary, fontSize: 17.0),
                                    cursorColor: FlutterFlowTheme.of(context).primary,
                                    validator: _model.textController4Validator.asValidator(context),
                                  ),
                                ),
                                // Email Cadastro
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      20.0, 0.0, 20.0, 0.0),
                                  child: TextFormField(
                                    controller: _model.textController5, 
                                    focusNode: _model.textFieldFocusNode5,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      labelStyle: FlutterFlowTheme.of(context).labelMedium.override(fontFamily: 'SF Pro Display', color: FlutterFlowTheme.of(context).black40, fontSize: 13.0),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: FlutterFlowTheme.of(context).tertiary, width: 1.0), borderRadius: BorderRadius.circular(12.0)),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: FlutterFlowTheme.of(context).tertiary, width: 1.0), borderRadius: BorderRadius.circular(12.0)),
                                      contentPadding: EdgeInsetsDirectional.fromSTEB(16.0, 13.0, 0.0, 12.0),
                                    ),
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'SF Pro Display', color: FlutterFlowTheme.of(context).tertiary, fontSize: 17.0),
                                    cursorColor: FlutterFlowTheme.of(context).primary,
                                    validator: _model.textController5Validator.asValidator(context),
                                  ),
                                ),
                                // Senha Cadastro
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      20.0, 0.0, 20.0, 0.0),
                                  child: TextFormField(
                                    controller: _model.textController6, 
                                    focusNode: _model.textFieldFocusNode6,
                                    textInputAction: TextInputAction.next,
                                    obscureText: !_model.passwordVisibility2,
                                    decoration: InputDecoration(
                                      labelText: 'Senha',
                                      labelStyle: FlutterFlowTheme.of(context).labelMedium.override(fontFamily: 'SF Pro Display', color: FlutterFlowTheme.of(context).black40, fontSize: 13.0),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: FlutterFlowTheme.of(context).tertiary, width: 1.0), borderRadius: BorderRadius.circular(12.0)),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: FlutterFlowTheme.of(context).tertiary, width: 1.0), borderRadius: BorderRadius.circular(12.0)),
                                      contentPadding: EdgeInsetsDirectional.fromSTEB(16.0, 13.0, 0.0, 12.0),
                                      suffixIcon: InkWell(
                                        onTap: () => safeSetState(() => _model.passwordVisibility2 = !_model.passwordVisibility2),
                                        focusNode: FocusNode(skipTraversal: true),
                                        child: Icon(_model.passwordVisibility2 ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: FlutterFlowTheme.of(context).black40, size: 24.0),
                                      ),
                                    ),
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'SF Pro Display', color: FlutterFlowTheme.of(context).tertiary, fontSize: 17.0),
                                    cursorColor: FlutterFlowTheme.of(context).primary,
                                    validator: _model.textController6Validator.asValidator(context),
                                  ),
                                ),

                                // --- [NOVO] CAMPO: ID DO RASTREADOR ---
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      20.0, 0.0, 20.0, 0.0),
                                  child: TextFormField(
                                    controller: _model.textController7, // Controlador novo
                                    focusNode: _model.textFieldFocusNode7,
                                    autofocus: false,
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                      labelText: 'ID do Rastreador',
                                      hintText: 'Digite o ID do dispositivo',
                                      labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                        fontFamily: 'SF Pro Display',
                                        color: FlutterFlowTheme.of(context).black40,
                                        fontSize: 13.0,
                                      ),
                                      hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                        fontFamily: 'Satoshi',
                                        color: FlutterFlowTheme.of(context).black40,
                                        fontSize: 17.0,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: FlutterFlowTheme.of(context).tertiary, width: 1.0),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: FlutterFlowTheme.of(context).tertiary, width: 1.0),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      contentPadding: EdgeInsetsDirectional.fromSTEB(16.0, 13.0, 0.0, 12.0),
                                    ),
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'SF Pro Display',
                                      color: FlutterFlowTheme.of(context).tertiary,
                                      fontSize: 17.0,
                                    ),
                                    cursorColor: FlutterFlowTheme.of(context).primary,
                                  ),
                                ),

                                // Botão CADASTRAR
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      20.0, 24.0, 20.0, 0.0),
                                  child: FFButtonWidget(
                                    onPressed: () async {
                                      if (_model.formKey2.currentState == null || !_model.formKey2.currentState!.validate()) {
                                        return;
                                      }

                                      String firstName = _model.textController3.text;
                                      String lastName = _model.textController4.text;
                                      String email = _model.textController5.text.trim();
                                      String password = _model.textController6.text;
                                      
                                      // [NOVO] Captura o ID do campo novo
                                      String trackerId = _model.textController7.text.trim(); 

                                      try {
                                        // 1. Cria usuário no Auth
                                        UserCredential userCredential = await FirebaseAuth.instance
                                            .createUserWithEmailAndPassword(email: email, password: password);

                                        String uid = userCredential.user!.uid;
                                        
                                        // 2. Salva no Firestore COM o trackerId
                                        await FirebaseFirestore.instance.collection('users').doc(uid).set({
                                          'firstName': firstName,
                                          'lastName': lastName,
                                          'email': email,
                                          'trackerId': trackerId, // Salvando aqui
                                          'uid': uid,
                                          'created_at': FieldValue.serverTimestamp(),
                                        });

                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Conta criada com sucesso!')));
                                        
                                        // 3. Volta para a aba de Login
                                        _model.tabBarController?.animateTo(0); 

                                      } on FirebaseAuthException catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: ${e.message}')));
                                      }
                                    },
                                    text: 'Cadastrar',
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
                              ].divide(SizedBox(height: 24.0)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}