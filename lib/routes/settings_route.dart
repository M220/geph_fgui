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
  late final settingsProvider = context.watch<SettingsProvider>();
  late AppLocalizations localizations;
  TextStyle? titleStyle;
  static const dialogTileTrailing = Icon(Icons.arrow_right, size: 40);
  static const tilesContentPadding = EdgeInsets.all(8);
  static const titlePadding = EdgeInsets.all(8);
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
    localizations = AppLocalizations.of(context)!;
    titleStyle = Theme.of(context).textTheme.titleLarge;
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
        padding: titlePadding,
        child: Text(
          localizations.general,
          style: titleStyle,
        ),
      ),
      ListTile(
        contentPadding: tilesContentPadding,
        leading: const Icon(Icons.language),
        title: Text(localizations.language),
        trailing: dialogTileTrailing,
        onTap: () async {
          Locale? selectedLocale = await showDialog(
              context: context,
              builder: (_) => LanguageDialog(
                    locale: settingsProvider.locale,
                  ));
          if (!context.mounted || selectedLocale == null) return;
          await settingsProvider.setLocale(selectedLocale);
        },
      ),
      ListTile(
        contentPadding: tilesContentPadding,
        leading: const Icon(Icons.nightlight),
        title: Text(localizations.theme),
        trailing: dialogTileTrailing,
        onTap: () async {
          ThemeMode? selectedThemeMode = await showDialog(
              context: context,
              builder: (_) =>
                  ThemeModeDialog(themeMode: settingsProvider.themeMode));

          if (!context.mounted || selectedThemeMode == null) return;
          await settingsProvider.setThemeMode(selectedThemeMode);
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
            builder: (_) => LoadingDialog(title: localizations.loggingOut));

        //TODO: Do cleanup here.
        await Future.delayed(const Duration(seconds: 2));

        if (!context.mounted) return;
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginRoute()));

        await settingsProvider.logout();
      },
      child: Text(
        localizations.logout,
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
        if (!context.mounted || confirmed == null) return;

        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) =>
                LoadingDialog(title: localizations.deletingAccount));

        final response =
            await Future.delayed(const Duration(seconds: 2), () => true);

        if (!context.mounted) return;
        Navigator.pop(context);

        if (!response) {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text(localizations.deleteAccountFailedTitle),
                    content: Text(localizations.deleteAccountFailedBlurb),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(localizations.ok)),
                    ],
                  ));
          return;
        }

        //TODO: Do other cleanup here
        await Future.delayed(Duration.zero, () => true);
        await settingsProvider.logout();
        if (!context.mounted) return;
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginRoute()));
      },
      child: Text(localizations.delete),
    );

    return [
      Padding(
        padding: titlePadding,
        child: Text(
          localizations.account,
          style: titleStyle,
        ),
      ),
      ListTile(
        contentPadding: tilesContentPadding,
        leading: const Icon(Icons.account_circle),
        title: Text(settingsProvider.accountData?.username ?? ""),
        trailing: logoutButton,
      ),
      ListTile(
        contentPadding: tilesContentPadding,
        leading: const Icon(Icons.delete_forever_outlined),
        title: Text(localizations.deleteAccount),
        subtitle: Text(localizations.deleteAccountBlurb),
        trailing: deleteButton,
      ),
    ];
  }

  List<Widget> _networkSectionWidgets() {
    final sectionTitle = Padding(
      padding: titlePadding,
      child: Text(
        localizations.network,
        style: titleStyle,
      ),
    );
    final vpnDependantWidgets = [
      SwitchListTile(
          contentPadding: tilesContentPadding,
          secondary: const Icon(Icons.fork_left),
          title: Text(localizations.excludePrc),
          subtitle: Text(localizations.excludePrcBlurb),
          value: settingsProvider.excludePRC,
          onChanged: (value) async {
            await settingsProvider.setExcludePRC(value);
          }),
      SwitchListTile(
          contentPadding: tilesContentPadding,
          secondary: const Icon(Icons.auto_awesome),
          title: Text(localizations.autoProxy),
          subtitle: Text(localizations.autoProxyBlurb),
          value: settingsProvider.autoProxy,
          onChanged: (value) async {
            await settingsProvider.setAutoProxy(value);
          }),
    ];

    if (Platform.isAndroid || Platform.isIOS) {
      return [
        sectionTitle,
        SwitchListTile(
            contentPadding: tilesContentPadding,
            secondary: const Icon(Icons.fork_left),
            title: Text(localizations.excludeApps),
            subtitle: Text(localizations.excludeAppsBlurb),
            value: settingsProvider.excludeApps,
            onChanged: (value) async {
              await settingsProvider.setExcludeApps(value);
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
              child: Text(localizations.selectExcludedApps),
            ),
          ),
        ),
      ];
    } else {
      return [
        sectionTitle,
        SwitchListTile(
            contentPadding: tilesContentPadding,
            secondary: const Icon(Icons.mediation),
            title: Text(localizations.globalVpn),
            subtitle: Text(localizations.globalVpnBlurb),
            value: settingsProvider.networkVPN,
            onChanged: (value) async {
              await settingsProvider.setNetworkVPN(value);
            }),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!settingsProvider.networkVPN) ...vpnDependantWidgets,
            ],
          ),
        ),
      ];
    }
  }

  List<Widget> _advancedSectionWidgets() {
    return [
      Padding(
        padding: titlePadding,
        child: Text(
          localizations.advanced,
          style: titleStyle,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade700),
                borderRadius: BorderRadius.circular(20)),
            child: Text(localizations.advancedWarning)),
      ),
      SwitchListTile(
          contentPadding: tilesContentPadding,
          secondary: const Icon(Icons.lan_outlined),
          title: Text(localizations.listenAll),
          subtitle: Text(localizations.listenAllBlurb),
          value: settingsProvider.listenAllInterfaces,
          onChanged: (value) async {
            await settingsProvider.setListenAllInterfaces(value);
          }),
      ListTile(
        contentPadding: tilesContentPadding,
        leading: const Icon(Icons.power),
        title: Text(localizations.listeningPorts),
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
        contentPadding: tilesContentPadding,
        leading: const Icon(Icons.network_cell),
        title: Text(localizations.routingMode),
        trailing: dialogTileTrailing,
        onTap: () async {
          final RoutingMode? routingMode = await showDialog(
              context: context,
              builder: (_) => RoutingModeDialog(
                    routingMode: settingsProvider.routingMode,
                  ));

          if (!context.mounted || routingMode == null) return;

          await settingsProvider.setRoutingMode(routingMode);
        },
      ),
      ListTile(
        contentPadding: tilesContentPadding,
        leading: const Icon(Icons.network_ping),
        title: Text(localizations.protocol),
        trailing: dialogTileTrailing,
        onTap: () async {
          final Protocol? protocol = await showDialog(
              context: context,
              builder: (_) =>
                  ProtocolDialog(protocol: settingsProvider.protocol));

          if (!context.mounted || protocol == null) return;

          await settingsProvider.setProtocol(protocol);
        },
      ),
    ];
  }

  List<Widget> _debugSectionWidgets() {
    return [
      Padding(
        padding: titlePadding,
        child: Text(
          localizations.debug,
          style: titleStyle,
        ),
      ),
      ListTile(
        contentPadding: tilesContentPadding,
        leading: const Icon(Icons.bug_report),
        title: Text(localizations.debugPack),
        subtitle: Text(localizations.debugPackBlurb),
        trailing: dialogTileTrailing,
        onTap: () async {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) =>
                  LoadingDialog(title: localizations.exportingDebug));

          await Future.delayed(const Duration(seconds: 3));
          await settingsProvider.exportLogFile();

          if (context.mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(SnackBar(
                  content: Text(
                "${localizations.debugExportedTo} ${settingsProvider.exportPath}",
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
        padding: titlePadding,
        child: Text(
          localizations.about,
          style: titleStyle,
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
                  label: Text(localizations.news)),
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
                  label: Text(localizations.forum)),
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
                  label: Text(localizations.github)),
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
