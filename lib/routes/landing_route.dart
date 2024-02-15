import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../routes/home_route.dart';
import '../routes/news_route.dart';
import '../routes/stats_route.dart';
import '../routes/settings_route.dart';

class LandingRoute extends StatefulWidget {
  const LandingRoute({super.key});

  @override
  State<LandingRoute> createState() => _LandingRouteState();
}

class _LandingRouteState extends State<LandingRoute>
    with SingleTickerProviderStateMixin {
  late final _settingsProvider = context.watch<SettingsProvider>();
  late final _tabController = TabController(length: 4, vsync: this);
  late AppLocalizations _localizations;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localizations = AppLocalizations.of(context)!;
    final settingsRead = context.read<SettingsProvider>();
    if (!settingsRead.lastNewsFetched) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          await settingsRead.fetchNewRss(context);
        } catch (_) {}
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: TabBar(controller: _tabController, tabs: [
          Tab(icon: const Icon(Icons.home_rounded), text: _localizations.home),
          Tab(
            icon: Icon(
              Icons.notifications_rounded,
              color: _settingsProvider.newNewsAvailable ? Colors.red : null,
            ),
            text: _localizations.news,
          ),
          Tab(icon: const Icon(Icons.data_object), text: _localizations.stats),
          Tab(
              icon: const Icon(Icons.settings_rounded),
              text: _localizations.settings),
        ]),
        body: TabBarView(
          controller: _tabController,
          children: const [
            HomeRoute(),
            NewsRoute(),
            StatsRoute(),
            SettingsRoute(),
          ],
        ),
      ),
    );
  }
}
