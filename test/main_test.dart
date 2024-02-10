import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:geph_fgui/data/account_data.dart';
import 'package:geph_fgui/main.dart';
import 'package:geph_fgui/constants.dart';
import 'package:geph_fgui/providers/settings_provider.dart';
import 'package:geph_fgui/routes/landing_route.dart';
import 'package:geph_fgui/routes/login_route.dart';
import 'path_provider_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  PathProviderPlatform.instance = FakePathProviderPlatform();

  // WidgetTester.runAsync() is needed because otherwise we'd get
  // stuck in a deadlock
  testWidgets("MainApp loads correct first page: LoginRoute",
      (widgetTester) async {
    await widgetTester.runAsync(() async {
      SharedPreferences.setMockInitialValues({});
      final settings = await SettingsProvider.instance();
      final bodyWidget = ChangeNotifierProvider.value(
        value: settings,
        child: const MainApp(),
      );

      await widgetTester.pumpWidget(bodyWidget);
      await widgetTester.pump();
      expect(find.byType(LoginRoute), findsOne);
      settings.dispose();
    });
  });

  testWidgets("MainApp loads correct first page: LandingRoute",
      (widgetTester) async {
    await widgetTester.runAsync(() async {
      SharedPreferences.setMockInitialValues({});
      final settings = await SettingsProvider.instance();
      const mockUsername = "mockUsername";
      const mockPassword = "mockPassword";
      const mockAccount =
          AccountData(username: mockUsername, password: mockPassword);
      await settings.setAccountData(mockAccount);
      final bodyWidget = ChangeNotifierProvider.value(
        value: settings,
        child: const MainApp(),
      );

      await widgetTester.pumpWidget(bodyWidget);
      await widgetTester.pumpAndSettle();
      // TODO: Added for now because of the fake auto server selection,
      // should be removed in the future.
      await Future.delayed(const Duration(seconds: 5));
      await widgetTester.pumpAndSettle();
      expect(find.byType(LandingRoute), findsOne);
      settings.dispose();
    });
  });

  testWidgets("MainApp loads correct properties", (widgetTester) async {
    await widgetTester.runAsync(() async {
      SharedPreferences.setMockInitialValues({});
      final settings = await SettingsProvider.instance();
      final bodyWidget = ChangeNotifierProvider.value(
        value: settings,
        child: const MainApp(),
      );
      await widgetTester.pumpWidget(bodyWidget);
      await widgetTester.pump();

      final materialApp =
          widgetTester.widget<MaterialApp>(find.byType(MaterialApp));

      expect(materialApp.theme, appLightTheme);
      expect(materialApp.darkTheme, appDarkTheme);
      expect(materialApp.themeMode, settings.themeMode);
      expect(materialApp.localizationsDelegates,
          AppLocalizations.localizationsDelegates);
      expect(materialApp.supportedLocales, AppLocalizations.supportedLocales);
      settings.dispose();
    });
  });
}
