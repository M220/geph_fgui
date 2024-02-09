import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geph_fgui/providers/settings_provider.dart';
import 'package:geph_fgui/routes/settings_route.dart';
import 'package:geph_fgui/widgets/language_dialog.dart';
import 'package:geph_fgui/widgets/protocol_dialog.dart';
import 'package:geph_fgui/widgets/routing_mode_dialog.dart';
import 'package:geph_fgui/widgets/theme_mode_dialog.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart'
    show FlexStringExtensions;

import '../path_provider_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  PathProviderPlatform.instance = FakePathProviderPlatform();

  testWidgets("SettingsRoute widgets are correct", (widgetTester) async {
    await widgetTester.runAsync(() async {
      late AppLocalizations localizations;
      SharedPreferences.setMockInitialValues({});
      final settings = await SettingsProvider.instance();
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
                            value: settings,
                            child: const Scaffold(body: SettingsRoute()))));
              },
              child: const Text("Hit"),
            ),
          );
        }),
      );
      await widgetTester.pumpWidget(bodyWidget);
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byType(ElevatedButton));
      await widgetTester.pumpAndSettle();

      expect(find.text(localizations.general), findsOne);
      expect(find.text(localizations.language), findsOne);

      settings.dispose();
    });
  });

  testWidgets("Language setting works", (widgetTester) async {
    await widgetTester.runAsync(() async {
      late AppLocalizations localizations;
      SharedPreferences.setMockInitialValues({});
      final settings = await SettingsProvider.instance();
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
                            value: settings,
                            child: const Scaffold(body: SettingsRoute()))));
              },
              child: const Text("Hit"),
            ),
          );
        }),
      );
      await widgetTester.pumpWidget(bodyWidget);
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byType(ElevatedButton));
      await widgetTester.pumpAndSettle();

      expect(settings.locale, null);

      await widgetTester.tap(find.text(localizations.language));
      await widgetTester.pump();

      expect(find.byType(LanguageDialog), findsOne);

      await widgetTester
          .tap(find.widgetWithText(TextButton, localizations.cancel));
      await widgetTester.pumpAndSettle();

      expect(settings.locale, null);

      await widgetTester.tap(find.text(localizations.language));
      await widgetTester.pump();

      await widgetTester.tap(find.text(localizations.english));
      await widgetTester.pump();
      await widgetTester.tap(find.widgetWithText(TextButton, localizations.ok));
      await widgetTester.pumpAndSettle();
      expect(find.byType(LanguageDialog), findsNothing);
      expect(settings.locale, englishLocale);

      await widgetTester.tap(find.text(localizations.language));
      await widgetTester.pump();

      await widgetTester.tap(find.text(localizations.persian));
      await widgetTester.pump();
      await widgetTester.tap(find.widgetWithText(TextButton, localizations.ok));
      await widgetTester.pumpAndSettle();
      expect(settings.locale, persianLocale);

      await widgetTester.tap(find.text(localizations.language));
      await widgetTester.pump();

      await widgetTester.tap(find.text(localizations.chineseCH));
      await widgetTester.pump();
      await widgetTester.tap(find.widgetWithText(TextButton, localizations.ok));
      await widgetTester.pumpAndSettle();
      expect(settings.locale, chineseCNLocale);

      await widgetTester.tap(find.text(localizations.language));
      await widgetTester.pump();

      await widgetTester.tap(find.text(localizations.chineseTW));
      await widgetTester.pump();
      await widgetTester.tap(find.widgetWithText(TextButton, localizations.ok));
      await widgetTester.pumpAndSettle();
      expect(settings.locale, chineseTWLocale);

      await widgetTester.tap(find.text(localizations.language));
      await widgetTester.pump();

      await widgetTester
          .tap(find.widgetWithText(TextButton, localizations.cancel));
      await widgetTester.pumpAndSettle();
      expect(settings.locale, chineseTWLocale);

      settings.dispose();
    });
  });

  testWidgets("ThemeMode setting works", (widgetTester) async {
    await widgetTester.runAsync(() async {
      late AppLocalizations localizations;
      SharedPreferences.setMockInitialValues({});
      final settings = await SettingsProvider.instance();
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
                            value: settings,
                            child: const Scaffold(body: SettingsRoute()))));
              },
              child: const Text("Hit"),
            ),
          );
        }),
      );
      await widgetTester.pumpWidget(bodyWidget);
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byType(ElevatedButton));
      await widgetTester.pumpAndSettle();

      expect(settings.themeMode, ThemeMode.system);

      await widgetTester.tap(find.text(localizations.theme));
      await widgetTester.pump();

      expect(find.byType(ThemeModeDialog), findsOne);

      await widgetTester
          .tap(find.widgetWithText(TextButton, localizations.cancel));
      await widgetTester.pumpAndSettle();

      expect(settings.themeMode, ThemeMode.system);

      await widgetTester.tap(find.text(localizations.theme));
      await widgetTester.pump();

      await widgetTester.tap(find.text(localizations.light));
      await widgetTester.pump();
      await widgetTester.tap(find.widgetWithText(TextButton, localizations.ok));
      await widgetTester.pumpAndSettle();
      expect(find.byType(ThemeModeDialog), findsNothing);
      expect(settings.themeMode, ThemeMode.light);

      await widgetTester.tap(find.text(localizations.theme));
      await widgetTester.pump();

      await widgetTester.tap(find.text(localizations.dark));
      await widgetTester.pump();
      await widgetTester.tap(find.widgetWithText(TextButton, localizations.ok));
      await widgetTester.pumpAndSettle();
      expect(settings.themeMode, ThemeMode.dark);

      await widgetTester.tap(find.text(localizations.theme));
      await widgetTester.pump();

      await widgetTester
          .tap(find.widgetWithText(TextButton, localizations.cancel));
      await widgetTester.pumpAndSettle();
      expect(settings.themeMode, ThemeMode.dark);

      await widgetTester.tap(find.text(localizations.theme));
      await widgetTester.pump();

      await widgetTester.tap(find.text(localizations.system));
      await widgetTester.pump();
      await widgetTester.tap(find.widgetWithText(TextButton, localizations.ok));
      await widgetTester.pumpAndSettle();
      expect(settings.themeMode, ThemeMode.system);

      settings.dispose();
    });
  });

  testWidgets("Protocol setting works", (widgetTester) async {
    await widgetTester.runAsync(() async {
      late AppLocalizations localizations;
      SharedPreferences.setMockInitialValues({});
      final settings = await SettingsProvider.instance();
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
                            value: settings,
                            child: const Scaffold(body: SettingsRoute()))));
              },
              child: const Text("Hit"),
            ),
          );
        }),
      );
      await widgetTester.pumpWidget(bodyWidget);
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byType(ElevatedButton));
      await widgetTester.pumpAndSettle();

      expect(settings.protocol, Protocol.auto);

      await widgetTester.scrollUntilVisible(
          find.text(localizations.protocol), 100);
      await widgetTester.tap(find.text(localizations.protocol));
      await widgetTester.pump();

      expect(find.byType(ProtocolDialog), findsOne);

      await widgetTester
          .tap(find.widgetWithText(TextButton, localizations.cancel));
      await widgetTester.pumpAndSettle();

      expect(settings.protocol, Protocol.auto);

      await widgetTester.tap(find.text(localizations.protocol));
      await widgetTester.pump();

      await widgetTester.tap(find.text("UDP"));
      await widgetTester.pump();
      await widgetTester.tap(find.widgetWithText(TextButton, localizations.ok));
      await widgetTester.pumpAndSettle();
      expect(find.byType(ProtocolDialog), findsNothing);
      expect(settings.protocol, Protocol.udp);

      await widgetTester.tap(find.text(localizations.protocol));
      await widgetTester.pump();

      await widgetTester.tap(find.text("TLS"));
      await widgetTester.pump();
      await widgetTester.tap(find.widgetWithText(TextButton, localizations.ok));
      await widgetTester.pumpAndSettle();
      expect(settings.protocol, Protocol.tls);

      await widgetTester.tap(find.text(localizations.protocol));
      await widgetTester.pump();

      await widgetTester
          .tap(find.widgetWithText(TextButton, localizations.cancel));
      await widgetTester.pumpAndSettle();
      expect(settings.protocol, Protocol.tls);

      await widgetTester.tap(find.text(localizations.protocol));
      await widgetTester.pump();

      await widgetTester.tap(find.text(localizations.automatic.capitalize));
      await widgetTester.pump();
      await widgetTester.tap(find.widgetWithText(TextButton, localizations.ok));
      await widgetTester.pumpAndSettle();
      expect(settings.protocol, Protocol.auto);

      settings.dispose();
    });
  });

  testWidgets("RoutingMode setting works", (widgetTester) async {
    await widgetTester.runAsync(() async {
      late AppLocalizations localizations;
      SharedPreferences.setMockInitialValues({});
      final settings = await SettingsProvider.instance();
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
                            value: settings,
                            child: const Scaffold(body: SettingsRoute()))));
              },
              child: const Text("Hit"),
            ),
          );
        }),
      );
      await widgetTester.pumpWidget(bodyWidget);
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byType(ElevatedButton));
      await widgetTester.pumpAndSettle();

      expect(settings.routingMode, RoutingMode.auto);

      await widgetTester.scrollUntilVisible(
          find.text(localizations.routingMode), 150);
      await widgetTester.tap(find.text(localizations.routingMode));
      await widgetTester.pump();

      expect(find.byType(RoutingModeDialog), findsOne);

      await widgetTester
          .tap(find.widgetWithText(TextButton, localizations.cancel));
      await widgetTester.pumpAndSettle();

      expect(settings.routingMode, RoutingMode.auto);

      await widgetTester.tap(find.text(localizations.routingMode));
      await widgetTester.pump();

      await widgetTester.tap(find.text(localizations.forceBridges));
      await widgetTester.pump();
      await widgetTester.tap(find.widgetWithText(TextButton, localizations.ok));
      await widgetTester.pumpAndSettle();
      expect(find.byType(RoutingModeDialog), findsNothing);
      expect(settings.routingMode, RoutingMode.bridges);

      await widgetTester.tap(find.text(localizations.routingMode));
      await widgetTester.pump();

      await widgetTester
          .tap(find.widgetWithText(TextButton, localizations.cancel));
      await widgetTester.pumpAndSettle();
      expect(settings.routingMode, RoutingMode.bridges);

      await widgetTester.tap(find.text(localizations.routingMode));
      await widgetTester.pump();

      await widgetTester.tap(find.text(localizations.automatic.capitalize));
      await widgetTester.pump();
      await widgetTester.tap(find.widgetWithText(TextButton, localizations.ok));
      await widgetTester.pumpAndSettle();
      expect(settings.routingMode, RoutingMode.auto);

      await widgetTester.tap(find.text(localizations.protocol));
      await widgetTester.pump();

      settings.dispose();
    });
  });
}
