import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vortexsales/core/nav/vx_nav.dart';
import 'package:vortexsales/core/state/app_controller.dart';
import 'package:vortexsales/core/state/store_controller.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/core/widgets/vx_aurora.dart';
import 'package:vortexsales/core/widgets/vx_link_strip.dart';
import 'package:vortexsales/features/bookings/bookings_screen.dart';
import 'package:vortexsales/features/catalog/catalog_screen.dart';
import 'package:vortexsales/features/channels/channels_screen.dart';
import 'package:vortexsales/features/first_run/coach_marks.dart';
import 'package:vortexsales/features/inbox/inbox_screen.dart';
import 'package:vortexsales/features/knowledge/knowledge_screen.dart';
import 'package:vortexsales/features/leads/leads_screen.dart';
import 'package:vortexsales/features/overview/overview_screen.dart';
import 'package:vortexsales/features/playground/playground_screen.dart';
import 'package:vortexsales/features/settings/settings_screen.dart';
import 'package:vortexsales/features/shell/app_topbar.dart';
import 'package:vortexsales/features/shell/mobile_nav.dart';
import 'package:vortexsales/features/shell/more_sheet.dart';
import 'package:vortexsales/features/shell/search_panel.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> with WidgetsBindingObserver {
  int _index = 0;
  int _coachStep = 0;
  String _query = '';
  bool _browsing = false;
  String? _openConversationId;
  bool _focusInboxReply = false;
  final _search = TextEditingController();
  final _inboxKey = GlobalKey();
  final _channelsKey = GlobalKey();
  final _catalogKey = GlobalKey();
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _search.addListener(_onSearch);
    VxNav.pending.addListener(_onNav);
    _poll = Timer.periodic(const Duration(seconds: 15), (_) {
      if (!mounted) return;
      StoreScope.of(context).refresh();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _onNav());
  }

  @override
  void dispose() {
    _poll?.cancel();
    VxNav.pending.removeListener(_onNav);
    WidgetsBinding.instance.removeObserver(this);
    _search.removeListener(_onSearch);
    _search.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      StoreScope.of(context).refresh();
      _onNav();
    }
  }

  void _onNav() {
    final intent = VxNav.take();
    if (intent == null || !mounted) return;
    setState(() {
      _index = intent.tab;
      _browsing = false;
      _openConversationId = intent.conversationId;
      _focusInboxReply = intent.focusReply;
    });
  }

  void _onSearch() {
    final q = _search.text;
    setState(() {
      _query = q;
      _browsing = q.trim().isNotEmpty;
    });
  }

  GlobalKey get _coachTarget {
    return switch (_coachStep) {
      0 => _inboxKey,
      1 => _channelsKey,
      _ => _catalogKey,
    };
  }

  Widget _pageFor(int index) {
    return switch (index) {
      0 => OverviewScreen(query: _query),
      1 => InboxScreen(
          query: _query,
          openId: _openConversationId,
          focusReply: _focusInboxReply,
          onOpened: () => setState(() {
            _openConversationId = null;
            _focusInboxReply = false;
          }),
        ),
      2 => ChannelsScreen(query: _query),
      3 => BookingsScreen(query: _query),
      4 => const PlaygroundScreen(),
      5 => KnowledgeScreen(query: _query),
      6 => CatalogScreen(query: _query, coachKey: _catalogKey),
      7 => LeadsScreen(query: _query),
      _ => SettingsScreen(
          onOpenChannels: () => setState(() {
            _index = 2;
            _browsing = false;
          }),
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final app = VxScope.of(context);

    return Scaffold(
      backgroundColor: VxColors.ink900,
      body: Stack(
        children: [
          VxAurora(
            child: Column(
              children: [
                SafeArea(
                  bottom: false,
                  child: AppTopbar(
                    search: _search,
                    onClear: () => _search.clear(),
                  ),
                ),
                VxLinkStrip(
                  onOpenServer: () => setState(() {
                    _index = 8;
                    _browsing = false;
                  }),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 280),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.02),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: KeyedSubtree(
                          key: ValueKey<int>(_index),
                          child: _pageFor(_index),
                        ),
                      ),
                      if (_browsing)
                        ColoredBox(
                          color: VxColors.ink900,
                          child: SearchPanel(
                            query: _query,
                            onOpen: (hit) {
                              setState(() {
                                _index = hit.tab;
                                _browsing = false;
                                _openConversationId = hit.conversationId;
                                _focusInboxReply = hit.conversationId != null;
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                MobileNav(
                  index: _index > 3 ? 4 : _index,
                  onSelect: (i) => setState(() {
                    _index = i;
                    _browsing = false;
                  }),
                  onMore: _openMore,
                  inboxKey: _inboxKey,
                  channelsKey: _channelsKey,
                  inboxBadge: StoreScope.of(context).needsYouCount,
                ),
              ],
            ),
          ),
          if (app.showCoach)
            CoachMarks(
              step: _coachStep,
              targetKey: _coachTarget,
              onSkip: app.completeCoach,
              onNext: () {
                if (_coachStep >= 2) {
                  app.completeCoach();
                } else {
                  setState(() {
                    _coachStep++;
                    if (_coachStep == 2) _index = 6;
                  });
                }
              },
            ),
        ],
      ),
    );
  }

  Future<void> _openMore() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(12),
        child: MoreSheet(
          onOpen: (i) => setState(() {
            _index = i;
            _browsing = false;
          }),
        ),
      ),
    );
  }
}
