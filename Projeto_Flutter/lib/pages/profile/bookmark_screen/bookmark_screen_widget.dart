import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/component/custom_center_appbar/custom_center_appbar_widget.dart';
import '/pages/component/ticket_container/ticket_container_widget.dart';
import '/pages/empty_componants/no_bookmark/no_bookmark_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'bookmark_screen_model.dart';
export 'bookmark_screen_model.dart';

class BookmarkScreenWidget extends StatefulWidget {
  const BookmarkScreenWidget({super.key});

  static String routeName = 'BookmarkScreen';
  static String routePath = '/bookmarkScreen';

  @override
  State<BookmarkScreenWidget> createState() => _BookmarkScreenWidgetState();
}

class _BookmarkScreenWidgetState extends State<BookmarkScreenWidget>
    with TickerProviderStateMixin {
  late BookmarkScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BookmarkScreenModel());

    animationsMap.addAll({
      'listViewOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 150.0.ms,
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
                  title: 'Bookmark ',
                  backIcon: false,
                  addIcon: false,
                  onTapAdd: () async {},
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    final bookmarkList = FFAppState().bookmarkList.toList();
                    if (bookmarkList.isEmpty) {
                      return NoBookmarkWidget();
                    }

                    return ListView.separated(
                      padding: EdgeInsets.fromLTRB(
                        0,
                        16.0,
                        0,
                        16.0,
                      ),
                      scrollDirection: Axis.vertical,
                      itemCount: bookmarkList.length,
                      separatorBuilder: (_, __) => SizedBox(height: 16.0),
                      itemBuilder: (context, bookmarkListIndex) {
                        final bookmarkListItem =
                            bookmarkList[bookmarkListIndex];
                        return wrapWithModel(
                          model: _model.ticketContainerModels.getModel(
                            bookmarkListItem.id.toString(),
                            bookmarkListIndex,
                          ),
                          updateCallback: () => safeSetState(() {}),
                          child: TicketContainerWidget(
                            key: Key(
                              'Keyqhv_${bookmarkListItem.id.toString()}',
                            ),
                            ticketInfo: bookmarkListItem,
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
