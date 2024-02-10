import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'routes/login_route.dart';
import 'routes/landing_route.dart';
import 'providers/settings_provider.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settingsProvider = await SettingsProvider.instance();

  runApp(ChangeNotifierProvider.value(
    value: settingsProvider,
    child: const MainApp(),
  ));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final _settings = context.watch<SettingsProvider>();
  late final _account = context.read<SettingsProvider>().accountData;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appLightTheme,
      darkTheme: appDarkTheme,
      themeMode: _settings.themeMode,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.geph,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _settings.locale,
      home: _account != null ? const LandingRoute() : const LoginRoute(),
    );
  }
}
