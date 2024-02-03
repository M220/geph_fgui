import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:xml/xml.dart';

import '../rss/rss_manager.dart';
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
  late final settingsProvider = context.watch<SettingsProvider>();
  late final _tabController = TabController(length: 4, vsync: this);
  late AppLocalizations localizations;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = AppLocalizations.of(context)!;
    final settingsRead = context.read<SettingsProvider>();
    if (!settingsRead.lastNewsFetched) {
      RssManager.getRss(context).then((value) {
        final fetchedNewsLength =
            XmlDocument.parse(value).findAllElements("item").toList().length;
        if (settingsRead.newsLoadedNumber < fetchedNewsLength) {
          setState(() {
            settingsRead.setNewNewsAvailable(true);
          });
        }
        settingsRead.setLastNewsFetched(true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: TabBar(controller: _tabController, tabs: [
          Tab(icon: const Icon(Icons.home_rounded), text: localizations.home),
          Tab(
            icon: Icon(
              Icons.notifications_rounded,
              color: settingsProvider.newNewsAvailable ? Colors.red : null,
            ),
            text: localizations.news,
          ),
          Tab(icon: const Icon(Icons.data_object), text: localizations.stats),
          Tab(
              icon: const Icon(Icons.settings_rounded),
              text: localizations.settings),
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
