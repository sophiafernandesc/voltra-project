import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/component/custom_center_appbar/custom_center_appbar_widget.dart';
import '/pages/component/ticket_container/ticket_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'upcomming_departures_screen_model.dart';
export 'upcomming_departures_screen_model.dart';

class UpcommingDeparturesScreenWidget extends StatefulWidget {
  const UpcommingDeparturesScreenWidget({super.key});

  static String routeName = 'UpcommingDeparturesScreen';
  static String routePath = '/upcommingDeparturesScreen';

  @override
  State<UpcommingDeparturesScreenWidget> createState() =>
      _UpcommingDeparturesScreenWidgetState();
}

class _UpcommingDeparturesScreenWidgetState
    extends State<UpcommingDeparturesScreenWidget>
    with TickerProviderStateMixin {
  late UpcommingDeparturesScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UpcommingDeparturesScreenModel());

    animationsMap.addAll({
      'listViewOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 50.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

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
                  title: 'Upcoming departures',
                  backIcon: false,
                  addIcon: false,
                  onTapAdd: () async {},
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    final updepall = FFAppState().updeparturesList.toList();

                    return ListView.separated(
                      padding: EdgeInsets.fromLTRB(
                        0,
                        16.0,
                        0,
                        16.0,
                      ),
                      scrollDirection: Axis.vertical,
                      itemCount: updepall.length,
                      separatorBuilder: (_, __) => SizedBox(height: 16.0),
                      itemBuilder: (context, updepallIndex) {
                        final updepallItem = updepall[updepallIndex];
                        return wrapWithModel(
                          model: _model.ticketContainerModels.getModel(
                            updepallItem.id.toString(),
                            updepallIndex,
                          ),
                          updateCallback: () => safeSetState(() {}),
                          child: TicketContainerWidget(
                            key: Key(
                              'Keydc4_${updepallItem.id.toString()}',
                            ),
                            ticketInfo: updepallItem,
                          ),
                        );
                      },
                    ).animateOnPageLoad(
                        animationsMap['listViewOnPageLoadAnimation']!);
                  },
                ),
              ),
            ].addToStart(SizedBox(height: 24.0)),
          ),
        ),
      ),
    );
  }
}
