import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Importa a nova tela daqui

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint("🚀 App starting...");

  try {
    debugPrint("🔥 Initializing Firebase...");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint("✅ Firebase initialized");
  } catch (e) {
    debugPrint("❌ Firebase error: $e");
    // Continua mesmo se Firebase falhar
  }

  try {
    GoRouter.optionURLReflectsImperativeAPIs = true;
    usePathUrlStrategy();
    debugPrint("✅ Router configured");
  } catch (e) {
    debugPrint("❌ Router error: $e");
  }

  try {
    debugPrint("💾 Initializing app state...");
    final appState = FFAppState();
    await appState.initializePersistedState();
    debugPrint("✅ App state initialized");

    runApp(ChangeNotifierProvider(
      create: (context) => appState,
      child: MyApp(),
    ));
  } catch (e) {
    debugPrint("❌ App state error: $e");
    // Fallback: inicia o app mesmo sem estado persistido
    runApp(ChangeNotifierProvider(
      create: (context) => FFAppState(),
      child: MyApp(),
    ));
  }
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  @override
  void initState() {
    super.initState();
    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);

    Future.delayed(Duration(milliseconds: 1000),
        () => safeSetState(() => _appStateNotifier.stopShowingSplashImage()));
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Voltrackar',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}

class NavBarPage extends StatefulWidget {
  NavBarPage({
    Key? key,
    this.initialPage,
    this.page,
    this.disableResizeToAvoidBottomInset = false,
  }) : super(key: key);

  final String? initialPage;
  final Widget? page;
  final bool disableResizeToAvoidBottomInset;

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

class _NavBarPageState extends State<NavBarPage> {
  String _currentPageName = 'HomeScreen';
  late Widget? _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPageName = widget.initialPage ?? _currentPageName;
    _currentPage = widget.page;
  }

  @override
  Widget build(BuildContext context) {
    // --- [ALTERAÇÃO 1] Atualizamos a lista de abas ---
    final tabs = {
      'HomeScreen': ObdPage(),
      'LocationScreen': LocationScreenWidget(),
      'TrackerInfoScreen': TrackerInfoScreenWidget(), // Nova tela aqui
      'ProfileScreen': ProfileScreenWidget(),
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);

    return Scaffold(
      resizeToAvoidBottomInset: !widget.disableResizeToAvoidBottomInset,
      body: _currentPage ?? tabs[_currentPageName],
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 70.0,
        color: FlutterFlowTheme.of(context).primaryText,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. HOME
            InkWell(
              onTap: () => safeSetState(() {
                _currentPage = null;
                _currentPageName = tabs.keys.toList()[0];
              }),
              child: Icon(
                currentIndex == 0 ? FFIcons.kacHome : FFIcons.khomeIc,
                size: 32.0,
                color: currentIndex == 0
                    ? FlutterFlowTheme.of(context).primary
                    : FlutterFlowTheme.of(context).black40,
              ),
            ),

            // 2. LOCALIZAÇÃO (MAPA)
            InkWell(
              onTap: () => safeSetState(() {
                _currentPage = null;
                _currentPageName = tabs.keys.toList()[1];
              }),
              child: Icon(
                currentIndex == 1 ? FFIcons.kacLocation : FFIcons.klocationIc,
                size: 32.0,
                color: currentIndex == 1
                    ? FlutterFlowTheme.of(context).primary
                    : FlutterFlowTheme.of(context).black40,
              ),
            ),

            // 3. STATUS DO RASTREADOR (ANTIGO GRÁFICO)
            // --- [ALTERAÇÃO 2] Mudamos o ícone para um Carro ---
            InkWell(
              onTap: () => safeSetState(() {
                _currentPage = null;
                _currentPageName = tabs.keys.toList()[2];
              }),
              child: Icon(
                // Usa ícone preenchido se selecionado, contorno se não
                currentIndex == 2
                    ? Icons.directions_car_filled
                    : Icons.directions_car_outlined,
                size: 32.0,
                color: currentIndex == 2
                    ? FlutterFlowTheme.of(context).primary
                    : FlutterFlowTheme.of(context).black40,
              ),
            ),

            // 4. PERFIL
            InkWell(
              onTap: () => safeSetState(() {
                _currentPage = null;
                _currentPageName = tabs.keys.toList()[3];
              }),
              child: Icon(
                currentIndex == 3
                    ? FFIcons.kacProfile
                    : Icons.person_outline_sharp,
                size: 32.0,
                color: currentIndex == 3
                    ? FlutterFlowTheme.of(context).primary
                    : FlutterFlowTheme.of(context).black40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
