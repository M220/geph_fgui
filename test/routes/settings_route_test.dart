import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geph_fgui/data/account_data.dart';
import 'package:geph_fgui/providers/settings_provider.dart';
import 'package:geph_fgui/routes/login_route.dart';
import 'package:geph_fgui/routes/settings_route.dart';
import 'package:geph_fgui/widgets/delete_account_dialog.dart';
import 'package:geph_fgui/widgets/language_dialog.dart';
import 'package:geph_fgui/widgets/loading_dialog.dart';
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

  testWidgets("Language setting works", (widgetTester) async {
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

  testWidgets("ThemeMode setting works", (widgetTester) async {
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

  testWidgets("logout works", (widgetTester) async {
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
                          value: settings,
                          child: const Scaffold(body: SettingsRoute()))));
            },
            child: const Text("Hit"),
          ),
        );
      }),
    );

    const mockUsername = "mockUsername";
    const mockPassword = "mockPassword";
    const mockAccount =
        AccountData(username: mockUsername, password: mockPassword);
    await settings.setAccountData(mockAccount);

    await widgetTester.pumpWidget(bodyWidget);
    await widgetTester.pumpAndSettle();
    await widgetTester.tap(find.byType(ElevatedButton));
    await widgetTester.pumpAndSettle();

    final findLogoutButton =
        find.widgetWithText(OutlinedButton, localizations.logout);

    await widgetTester.scrollUntilVisible(findLogoutButton, 100);
    await widgetTester.ensureVisible(findLogoutButton);
    await widgetTester.pumpAndSettle();
    await widgetTester.tap(findLogoutButton);
    await widgetTester.pump();
    expect(find.byType(LoadingDialog), findsOne);
    expect(find.text(localizations.loggingOut), findsOne);
    await widgetTester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.byType(LoadingDialog), findsNothing);
    expect(find.byType(LoginRoute), findsOne);
    expect(settings.accountData, null);

    settings.dispose();
  });

  testWidgets("deleteAccount works", (widgetTester) async {
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
                          value: settings,
                          child: const Scaffold(body: SettingsRoute()))));
            },
            child: const Text("Hit"),
          ),
        );
      }),
    );

    const mockUsername = "mockUsername";
    const mockPassword = "mockPassword";
    const mockAccount =
        AccountData(username: mockUsername, password: mockPassword);
    await settings.setAccountData(mockAccount);

    await widgetTester.pumpWidget(bodyWidget);
    await widgetTester.pumpAndSettle();
    await widgetTester.tap(find.byType(ElevatedButton));
    await widgetTester.pumpAndSettle();

    final findDeleteButton =
        find.widgetWithText(TextButton, localizations.delete);
    final findOkButton = find.widgetWithText(TextButton, localizations.ok);
    final findCancelButton =
        find.widgetWithText(TextButton, localizations.cancel);
    final offStageWidget = find.byWidget(bodyWidget, skipOffstage: false);

    await widgetTester.scrollUntilVisible(findDeleteButton, 100);
    await widgetTester.ensureVisible(findDeleteButton);
    await widgetTester.pumpAndSettle();
    await widgetTester.tap(findDeleteButton);
    await widgetTester.pump();
    expect(find.byType(DeleteAccountDialog), findsOne);
    await widgetTester.tapAt(widgetTester.getTopLeft(offStageWidget));
    await widgetTester.pumpAndSettle();
    expect(find.byType(DeleteAccountDialog), findsNothing);
    expect(settings.accountData, mockAccount);

    await widgetTester.tap(findDeleteButton);
    await widgetTester.pump();
    await widgetTester.tap(findCancelButton);
    await widgetTester.pumpAndSettle();
    expect(find.byType(DeleteAccountDialog), findsNothing);
    expect(settings.accountData, mockAccount);

    await widgetTester.tap(findDeleteButton);
    await widgetTester.pump();
    await widgetTester.tap(findOkButton);
    await widgetTester.pump();
    expect(find.byType(LoadingDialog), findsOne);
    expect(find.text(localizations.deletingAccount), findsOne);
    await widgetTester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.byType(LoadingDialog), findsNothing);
    expect(find.byType(LoginRoute), findsOne);
    expect(settings.accountData, null);

    settings.dispose();
  });

  testWidgets("Protocol setting works", (widgetTester) async {
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

    final findProtocolTile = find.text(localizations.protocol);
    final findCancelButton =
        find.widgetWithText(TextButton, localizations.cancel);
    final findOkButton = find.widgetWithText(TextButton, localizations.ok);

    await widgetTester.scrollUntilVisible(findProtocolTile, 100);
    await widgetTester.ensureVisible(findProtocolTile);
    await widgetTester.pumpAndSettle();
    await widgetTester.tap(findProtocolTile);
    await widgetTester.pump();

    expect(find.byType(ProtocolDialog), findsOne);

    await widgetTester.tap(findCancelButton);
    await widgetTester.pumpAndSettle();

    expect(settings.protocol, Protocol.auto);

    await widgetTester.tap(findProtocolTile);
    await widgetTester.pump();

    await widgetTester.tap(find.text("UDP"));
    await widgetTester.pump();
    await widgetTester.tap(findOkButton);
    await widgetTester.pumpAndSettle();
    expect(find.byType(ProtocolDialog), findsNothing);
    expect(settings.protocol, Protocol.udp);

    await widgetTester.tap(findProtocolTile);
    await widgetTester.pump();

    await widgetTester.tap(find.text("TLS"));
    await widgetTester.pump();
    await widgetTester.tap(findOkButton);
    await widgetTester.pumpAndSettle();
    expect(settings.protocol, Protocol.tls);

    await widgetTester.tap(findProtocolTile);
    await widgetTester.pump();

    await widgetTester.tap(findCancelButton);
    await widgetTester.pumpAndSettle();
    expect(settings.protocol, Protocol.tls);

    await widgetTester.tap(findProtocolTile);
    await widgetTester.pump();

    await widgetTester.tap(find.text(localizations.automatic.capitalize));
    await widgetTester.pump();
    await widgetTester.tap(findOkButton);
    await widgetTester.pumpAndSettle();
    expect(settings.protocol, Protocol.auto);

    settings.dispose();
  });

  testWidgets("RoutingMode setting works", (widgetTester) async {
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

    final findRoutingModeTile = find.text(localizations.routingMode);
    final findCancelButton =
        find.widgetWithText(TextButton, localizations.cancel);
    final findOkButton = find.widgetWithText(TextButton, localizations.ok);

    await widgetTester.scrollUntilVisible(findRoutingModeTile, 100);
    await widgetTester.ensureVisible(findRoutingModeTile);
    await widgetTester.pumpAndSettle();
    await widgetTester.tap(findRoutingModeTile);
    await widgetTester.pump();

    expect(find.byType(RoutingModeDialog), findsOne);

    await widgetTester.tap(findCancelButton);
    await widgetTester.pumpAndSettle();

    expect(settings.routingMode, RoutingMode.auto);

    await widgetTester.tap(findRoutingModeTile);
    await widgetTester.pump();

    await widgetTester.tap(find.text(localizations.forceBridges));
    await widgetTester.pump();
    await widgetTester.tap(findOkButton);
    await widgetTester.pumpAndSettle();
    expect(find.byType(RoutingModeDialog), findsNothing);
    expect(settings.routingMode, RoutingMode.bridges);

    await widgetTester.tap(findRoutingModeTile);
    await widgetTester.pump();

    await widgetTester.tap(findCancelButton);
    await widgetTester.pumpAndSettle();
    expect(settings.routingMode, RoutingMode.bridges);

    await widgetTester.tap(findRoutingModeTile);
    await widgetTester.pump();

    await widgetTester.tap(find.text(localizations.automatic.capitalize));
    await widgetTester.pump();
    await widgetTester.tap(findOkButton);
    await widgetTester.pumpAndSettle();
    expect(settings.routingMode, RoutingMode.auto);

    settings.dispose();
  });

  testWidgets("NetworkVPN works", (widgetTester) async {
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

    expect(settings.networkVPN, false);
    expect(find.text(localizations.autoProxy), findsOne);
    expect(find.text(localizations.excludePrc), findsOne);

    final findGlobalVpnTile = find.text(localizations.globalVpn);
    final findExcludePRCTile = find.text(localizations.excludePrc);
    final findAutoProxyTile = find.text(localizations.autoProxy);

    await widgetTester.ensureVisible(findGlobalVpnTile);
    await widgetTester.tap(findGlobalVpnTile);
    await widgetTester.pumpAndSettle();
    expect(settings.networkVPN, true);
    expect(findExcludePRCTile, findsNothing);
    expect(findAutoProxyTile, findsNothing);

    await widgetTester.tap(findGlobalVpnTile);
    await widgetTester.pumpAndSettle();
    expect(settings.networkVPN, false);
    expect(findExcludePRCTile, findsOne);
    expect(findAutoProxyTile, findsOne);

    settings.dispose();
  });

  testWidgets("excludePRC works", (widgetTester) async {
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

    expect(settings.excludePRC, false);

    final findExcludePRCTile = find.text(localizations.excludePrc);

    await widgetTester.scrollUntilVisible(findExcludePRCTile, 100);
    await widgetTester.ensureVisible(findExcludePRCTile);
    await widgetTester.pumpAndSettle();
    await widgetTester.tap(findExcludePRCTile);
    await widgetTester.pumpAndSettle();
    expect(settings.excludePRC, true);

    await widgetTester.tap(findExcludePRCTile);
    await widgetTester.pumpAndSettle();
    expect(settings.excludePRC, false);

    settings.dispose();
  });

  testWidgets("autoProxy works", (widgetTester) async {
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

    expect(settings.autoProxy, true);

    final findAutoProxyTile = find.text(localizations.autoProxy);

    await widgetTester.scrollUntilVisible(findAutoProxyTile, 100);
    await widgetTester.ensureVisible(findAutoProxyTile);
    await widgetTester.pumpAndSettle();
    await widgetTester.tap(findAutoProxyTile);
    await widgetTester.pumpAndSettle();
    expect(settings.autoProxy, false);

    await widgetTester.tap(findAutoProxyTile);
    await widgetTester.pumpAndSettle();
    expect(settings.autoProxy, true);

    settings.dispose();
  });
}
