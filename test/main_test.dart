import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:geph_fgui/data/account_data.dart';
import 'package:geph_fgui/main.dart';
import 'package:geph_fgui/providers/settings_provider.dart';
import 'package:geph_fgui/routes/landing_route.dart';
import 'package:geph_fgui/routes/login_route.dart';
import 'path_provider_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  PathProviderPlatform.instance = FakePathProviderPlatform();

  group('', () {
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
        await widgetTester.pump();
        expect(find.byType(LandingRoute), findsOne);
        settings.dispose();
      });
    });
  });
}
