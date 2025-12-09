import 'package:firebase_core/firebase_core.dart'; 
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Conecta com o Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState();

  runApp(ChangeNotifierProvider(
    create: (context) => appState,
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  String getRoute([RouteMatch? routeMatch]) {
    final RouteMatch lastMatch =
        routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router.routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }

  List<String> getRouteStack() =>
      _router.routerDelegate.currentConfiguration.matches
          .map((e) => getRoute(e))
          .toList();
  bool displaySplashImage = true;

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

/// This is the private State class that goes with NavBarPage.
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
    final tabs = {
      'HomeScreen': HomeScreenWidget(),
      'LocationScreen': LocationScreenWidget(),
      'ScheduleScreen': ScheduleScreenWidget(),
      'ProfileScreen': ProfileScreenWidget(),
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);

    return Scaffold(
      resizeToAvoidBottomInset: !widget.disableResizeToAvoidBottomInset,
      body: _currentPage ?? tabs[_currentPageName],
      // SUBSTITUA O bottomNavigationBar ANTIGO POR ESTE:
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 70.0, // Altura fixa (pode aumentar/diminuir se quiser)
        color: FlutterFlowTheme.of(context).primaryText, // Cor de fundo
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround, // Espaça os ícones igualmente
          crossAxisAlignment: CrossAxisAlignment.center,    // Centraliza verticalmente (Resolve o "torto")
          children: [
            // --- ITEM 1: HOME ---
            InkWell(
              onTap: () => safeSetState(() {
                _currentPage = null;
                _currentPageName = tabs.keys.toList()[0];
              }),
              child: Icon(
                // Troca o ícone se estiver ativo ou inativo
                currentIndex == 0 ? FFIcons.kacHome : FFIcons.khomeIc,
                size: 32.0,
                color: currentIndex == 0
                    ? FlutterFlowTheme.of(context).primary
                    : FlutterFlowTheme.of(context).black40,
              ),
            ),

            // --- ITEM 2: LOCALIZAÇÃO ---
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

            // --- ITEM 3: GRÁFICO (SVG) ---
            InkWell(
              onTap: () => safeSetState(() {
                _currentPage = null;
                _currentPageName = tabs.keys.toList()[2];
              }),
              child: SvgPicture.asset(
                'assets/images/graph.svg',
                width: 32.0,
                height: 32.0,
                colorFilter: ColorFilter.mode(
                  currentIndex == 2
                      ? FlutterFlowTheme.of(context).primary
                      : FlutterFlowTheme.of(context).black40,
                  BlendMode.srcIn,
                ),
              ),
            ),

            // --- ITEM 4: PERFIL ---
            InkWell(
              onTap: () => safeSetState(() {
                _currentPage = null;
                _currentPageName = tabs.keys.toList()[3];
              }),
              child: Icon(
                // Notei que no seu código original, o inativo era um ícone diferente
                currentIndex == 3 ? FFIcons.kacProfile : Icons.person_outline_sharp,
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
