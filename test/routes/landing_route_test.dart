import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geph_fgui/routes/home_route.dart';
import 'package:geph_fgui/routes/landing_route.dart';
import 'package:geph_fgui/routes/news_route.dart';
import 'package:geph_fgui/routes/settings_route.dart';
import 'package:geph_fgui/routes/stats_route.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:geph_fgui/providers/settings_provider.dart';
import '../path_provider_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  PathProviderPlatform.instance = FakePathProviderPlatform();

  testWidgets("LandingRoute is working correctly", (widgetTester) async {
    late AppLocalizations localizations;
    SharedPreferences.setMockInitialValues({});
    late final SettingsProvider settings;
    await widgetTester.runAsync(() async {
      settings = await SettingsProvider.instance();
    });
    final bodyWidget = MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(builder: (context) {
        return Scaffold(
          body: ElevatedButton(
            onPressed: () async {
              localizations = AppLocalizations.of(context)!;
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ChangeNotifierProvider.value(
                          value: settings, child: const LandingRoute())));
            },
            child: const Text("Hit"),
          ),
        );
      }),
    );
    settings.setLastNewsFetched(true);
    await widgetTester.pumpWidget(bodyWidget);
    await widgetTester.pumpAndSettle();
    await widgetTester.tap(find.byType(ElevatedButton));
    await widgetTester.pumpAndSettle();

    final tabBarView =
        widgetTester.widget<TabBarView>(find.byType(TabBarView)).children;
    expect(find.byType(Tab), findsExactly(4));
    expect(find.byType(TabBarView), findsExactly(1));
    expect(tabBarView.length, 4);
    expect(tabBarView.any((element) => element is HomeRoute), true);
    expect(tabBarView.any((element) => element is NewsRoute), true);
    expect(tabBarView.any((element) => element is StatsRoute), true);
    expect(tabBarView.any((element) => element is SettingsRoute), true);
    expect(find.byIcon(Icons.home_rounded), findsOne);
    expect(find.text(localizations.home), findsOne);
    expect(find.byIcon(Icons.notifications_rounded), findsOne);
    expect(find.text(localizations.news), findsOne);
    expect(find.byIcon(Icons.data_object), findsOne);
    expect(find.text(localizations.stats), findsOne);
    expect(find.byIcon(Icons.settings_rounded), findsOne);
    expect(find.text(localizations.settings), findsOne);
    expect(find.byType(HomeRoute), findsOne);

    await widgetTester.tap(find.byIcon(Icons.notifications_rounded));
    await widgetTester.pumpAndSettle();
    expect(find.byType(NewsRoute), findsOne);

    await widgetTester.tap(find.byIcon(Icons.data_object));
    await widgetTester.pumpAndSettle();
    expect(find.byType(StatsRoute), findsOne);

    await widgetTester.tap(find.byIcon(Icons.settings_rounded));
    await widgetTester.pumpAndSettle();
    expect(find.byType(SettingsRoute), findsOne);

    await widgetTester.tap(find.byIcon(Icons.home_rounded));
    await widgetTester.pumpAndSettle();
    expect(find.byType(HomeRoute), findsOne);

    expect(
        widgetTester
            .widget<Icon>(find.byIcon(Icons.notifications_rounded))
            .color,
        null);
    settings.setNewNewsAvailable(true);
    await widgetTester.pumpAndSettle();
    expect(
        widgetTester
            .widget<Icon>(find.byIcon(Icons.notifications_rounded))
            .color,
        Colors.red);
  });
}
