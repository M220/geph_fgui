import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../routes/excluded_apps_route.dart';
import '../routes/login_route.dart';
import '../widgets/delete_account_dialog.dart';
import '../widgets/routing_mode_dialog.dart';
import '../widgets/protocol_dialog.dart';
import '../widgets/loading_dialog.dart';
import '../widgets/language_dialog.dart';
import '../widgets/theme_mode_dialog.dart';
import '../providers/settings_provider.dart';

const String _telegramUrl = "https://t.me/s/gephannounce";
const String _forumUrl = "https://community.geph.io";
const String _githubUrl = "https://github.com/geph-official";

class SettingsRoute extends StatefulWidget {
  const SettingsRoute({super.key});

  @override
  State<SettingsRoute> createState() => _SettingsRouteState();
}

class _SettingsRouteState extends State<SettingsRoute> {
  late final _settingsProvider = context.watch<SettingsProvider>();
  late AppLocalizations _localizations;
  TextStyle? _titleStyle;
  static const _dialogTileTrailing = Icon(Icons.arrow_right, size: 40);
  static const _tilesContentPadding = EdgeInsets.all(8);
  static const _titlePadding = EdgeInsets.all(8);
  static const _divider = Padding(
    padding: EdgeInsets.all(8.0),
    child: Divider(
      height: 2,
      color: Colors.grey,
    ),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localizations = AppLocalizations.of(context)!;
    _titleStyle = Theme.of(context).textTheme.titleLarge;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        key: const PageStorageKey("Settings"),
        children: [
          ..._generalSectionWidgets(),
          _divider,
          ..._accountSectionWidgets(),
          _divider,
          ..._networkSectionWidgets(),
          _divider,
          ..._advancedSectionWidgets(),
          _divider,
          ..._debugSectionWidgets(),
          _divider,
          ..._aboutSectionWidgets(),
        ],
      ),
    );
  }

  List<Widget> _generalSectionWidgets() {
    return [
      Padding(
        padding: _titlePadding,
        child: Text(
          _localizations.general,
          style: _titleStyle,
        ),
      ),
      ListTile(
        contentPadding: _tilesContentPadding,
        leading: const Icon(Icons.language),
        title: Text(_localizations.language),
        trailing: _dialogTileTrailing,
        onTap: () async {
          Locale? selectedLocale = await showDialog(
              context: context,
              builder: (_) => LanguageDialog(
                    locale: _settingsProvider.locale,
                  ));
          if (!context.mounted || selectedLocale == null) return;
          await _settingsProvider.setLocale(selectedLocale);
        },
      ),
      ListTile(
        contentPadding: _tilesContentPadding,
        leading: const Icon(Icons.nightlight),
        title: Text(_localizations.theme),
        trailing: _dialogTileTrailing,
        onTap: () async {
          ThemeMode? selectedThemeMode = await showDialog(
              context: context,
              builder: (_) =>
                  ThemeModeDialog(themeMode: _settingsProvider.themeMode));

          if (!context.mounted || selectedThemeMode == null) return;
          await _settingsProvider.setThemeMode(selectedThemeMode);
        },
      ),
    ];
  }

  List<Widget> _accountSectionWidgets() {
    final logoutButton = OutlinedButton(
      style: ButtonStyle(
        overlayColor: MaterialStatePropertyAll(Colors.red.withOpacity(0.15)),
        foregroundColor: const MaterialStatePropertyAll(Colors.red),
        side: const MaterialStatePropertyAll(BorderSide(color: Colors.red)),
      ),
      onPressed: () async {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) => LoadingDialog(title: _localizations.loggingOut));

        //TODO: Do cleanup here.
        await Future.delayed(const Duration(seconds: 2));

        await _settingsProvider.logout();

        if (!context.mounted) return;
        Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginRoute()));
      },
      child: Text(
        _localizations.logout,
      ),
    );

    final deleteButton = TextButton(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.hovered) ||
              states.contains(MaterialState.pressed)) {
            return Colors.white.withOpacity(0.10);
          }
          return null;
        }),
        backgroundColor: const MaterialStatePropertyAll(Colors.red),
        foregroundColor: const MaterialStatePropertyAll(Colors.white),
      ),
      onPressed: () async {
        final bool? confirmed = await showDialog(
            context: context, builder: (_) => const DeleteAccountDialog());
        if (!context.mounted || confirmed != true) return;

        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) =>
                LoadingDialog(title: _localizations.deletingAccount));

        final response =
            await Future.delayed(const Duration(seconds: 2), () => true);

        if (!context.mounted) return;
        Navigator.pop(context);

        if (!response) {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text(_localizations.deleteAccountFailedTitle),
                    content: Text(_localizations.deleteAccountFailedBlurb),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(_localizations.ok)),
                    ],
                  ));
          return;
        }

        //TODO: Do other cleanup here
        await Future.delayed(Duration.zero, () => true);
        await _settingsProvider.logout();
        if (!context.mounted) return;
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginRoute()));
      },
      child: Text(_localizations.delete),
    );

    return [
      Padding(
        padding: _titlePadding,
        child: Text(
          _localizations.account,
          style: _titleStyle,
        ),
      ),
      ListTile(
        contentPadding: _tilesContentPadding,
        leading: const Icon(Icons.account_circle),
        title: Text(_settingsProvider.accountData?.username ?? ""),
        trailing: logoutButton,
      ),
      ListTile(
        contentPadding: _tilesContentPadding,
        leading: const Icon(Icons.delete_forever_outlined),
        title: Text(_localizations.deleteAccount),
        subtitle: Text(_localizations.deleteAccountBlurb),
        trailing: deleteButton,
      ),
    ];
  }

  List<Widget> _networkSectionWidgets() {
    final sectionTitle = Padding(
      padding: _titlePadding,
      child: Text(
        _localizations.network,
        style: _titleStyle,
      ),
    );
    final vpnDependantWidgets = [
      SwitchListTile(
          contentPadding: _tilesContentPadding,
          secondary: const Icon(Icons.fork_left),
          title: Text(_localizations.excludePrc),
          subtitle: Text(_localizations.excludePrcBlurb),
          value: _settingsProvider.excludePRC,
          onChanged: (value) async {
            await _settingsProvider.setExcludePRC(value);
          }),
      SwitchListTile(
          contentPadding: _tilesContentPadding,
          secondary: const Icon(Icons.auto_awesome),
          title: Text(_localizations.autoProxy),
          subtitle: Text(_localizations.autoProxyBlurb),
          value: _settingsProvider.autoProxy,
          onChanged: (value) async {
            await _settingsProvider.setAutoProxy(value);
          }),
    ];

    if (Platform.isAndroid || Platform.isIOS) {
      return [
        sectionTitle,
        SwitchListTile(
            contentPadding: _tilesContentPadding,
            secondary: const Icon(Icons.fork_left),
            title: Text(_localizations.excludeApps),
            subtitle: Text(_localizations.excludeAppsBlurb),
            value: _settingsProvider.excludeApps,
            onChanged: (value) async {
              await _settingsProvider.setExcludeApps(value);
            }),
        SizedBox(
          height: 40,
          child: Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: OutlinedButton(
              onPressed: () {
                //TODO: Do stuff here.
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ExcludedAppsRoute()));
              },
              child: Text(_localizations.selectExcludedApps),
            ),
          ),
        ),
      ];
    } else {
      return [
        sectionTitle,
        SwitchListTile(
            contentPadding: _tilesContentPadding,
            secondary: const Icon(Icons.mediation),
            title: Text(_localizations.globalVpn),
            subtitle: Text(_localizations.globalVpnBlurb),
            value: _settingsProvider.networkVPN,
            onChanged: (value) async {
              await _settingsProvider.setNetworkVPN(value);
            }),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_settingsProvider.networkVPN) ...vpnDependantWidgets,
            ],
          ),
        ),
      ];
    }
  }

  List<Widget> _advancedSectionWidgets() {
    return [
      Padding(
        padding: _titlePadding,
        child: Text(
          _localizations.advanced,
          style: _titleStyle,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade700),
                borderRadius: BorderRadius.circular(20)),
            child: Text(_localizations.advancedWarning)),
      ),
      SwitchListTile(
          contentPadding: _tilesContentPadding,
          secondary: const Icon(Icons.lan_outlined),
          title: Text(_localizations.listenAll),
          subtitle: Text(_localizations.listenAllBlurb),
          value: _settingsProvider.listenAllInterfaces,
          onChanged: (value) async {
            await _settingsProvider.setListenAllInterfaces(value);
          }),
      ListTile(
        contentPadding: _tilesContentPadding,
        leading: const Icon(Icons.power),
        title: Text(_localizations.listeningPorts),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "9909",
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Text(
                    "SOCKS5",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "9910",
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Text(
                    "HTTP",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      ListTile(
        contentPadding: _tilesContentPadding,
        leading: const Icon(Icons.network_cell),
        title: Text(_localizations.routingMode),
        trailing: _dialogTileTrailing,
        onTap: () async {
          final RoutingMode? routingMode = await showDialog(
              context: context,
              builder: (_) => RoutingModeDialog(
                    routingMode: _settingsProvider.routingMode,
                  ));

          if (!context.mounted || routingMode == null) return;

          await _settingsProvider.setRoutingMode(routingMode);
        },
      ),
      ListTile(
        contentPadding: _tilesContentPadding,
        leading: const Icon(Icons.network_ping),
        title: Text(_localizations.protocol),
        trailing: _dialogTileTrailing,
        onTap: () async {
          final Protocol? protocol = await showDialog(
              context: context,
              builder: (_) =>
                  ProtocolDialog(protocol: _settingsProvider.protocol));

          if (!context.mounted || protocol == null) return;

          await _settingsProvider.setProtocol(protocol);
        },
      ),
    ];
  }

  List<Widget> _debugSectionWidgets() {
    return [
      Padding(
        padding: _titlePadding,
        child: Text(
          _localizations.debug,
          style: _titleStyle,
        ),
      ),
      ListTile(
        contentPadding: _tilesContentPadding,
        leading: const Icon(Icons.bug_report),
        title: Text(_localizations.debugPack),
        subtitle: Text(_localizations.debugPackBlurb),
        trailing: _dialogTileTrailing,
        onTap: () async {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) =>
                  LoadingDialog(title: _localizations.exportingDebug));

          await Future.delayed(const Duration(seconds: 3));
          await _settingsProvider.exportLogFile();

          if (context.mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(SnackBar(
                  content: Text(
                "${_localizations.debugExportedTo} ${_settingsProvider.exportPath}",
                style: TextStyle(
                    color: Colors.green.shade700,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )));
          }
        },
      ),
    ];
  }

  List<Widget> _aboutSectionWidgets() {
    return [
      Padding(
        padding: _titlePadding,
        child: Text(
          _localizations.about,
          style: _titleStyle,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ElevatedButton.icon(
                  onPressed: () async {
                    final url = Uri.parse(_telegramUrl);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  },
                  icon: const Icon(Icons.telegram),
                  label: Text(_localizations.news)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                  onPressed: () async {
                    final url = Uri.parse(_forumUrl);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  },
                  icon: const Icon(Icons.forum),
                  label: Text(_localizations.forum)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                  onPressed: () async {
                    final url = Uri.parse(_githubUrl);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  },
                  icon: const Icon(Icons.code),
                  label: Text(_localizations.github)),
            ),
          ],
        ),
      ),
      const SizedBox(height: 8),
      const Center(child: Text("v4.10.1")),
      const SizedBox(height: 8),
      const Center(
          child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("made with "),
          Card(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(1),
              child: Icon(
                Icons.favorite_rounded,
                color: Colors.red,
              ),
            ),
          ),
          Text(" by"),
        ],
      )),
      const Center(child: Text("@nullchincilla / Gephyra OU")),
    ];
  }
}
