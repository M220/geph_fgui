import 'package:flutter/material.dart';
import 'package:flag/flag.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../helpers/address_localization_helper.dart' as h;
import '../data/server_info.dart';
import '../providers/settings_provider.dart';
import '../interfaces/connection_manager.dart';
import '../routes/server_selection_route.dart';
import '../widgets/loading_dialog.dart';
import '../constants.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({super.key});

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  late final _settingsProvider = context.watch<SettingsProvider>();
  late AppLocalizations _localizations;
  late Map<String, String> _localizedCity;
  late ServerInfo? _selectedServer;
  final int _remainingDays = 150;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localizations = AppLocalizations.of(context)!;
    _localizedCity = h.getLocalizedCityMap(_localizations);
    _selectedServer = _settingsProvider.selectedServer;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: constraints.maxHeight <= scrollingHeight
                  ? scrollingHeight
                  : constraints.maxHeight,
            ),
            child: Column(
              children: [
                ..._topSectionWidgets(),
                Expanded(
                  flex: 4,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [..._middleSectionWidgets()],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [..._bottomSectionWidgets()],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _topSectionWidgets() {
    return [
      ListTile(
        leading: Icon(
          Icons.calendar_month,
          color: Theme.of(context).primaryColor,
        ),
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text("Jun 7, 2024"),
        ),
        subtitle: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.shade200
                  : Colors.grey.shade700,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.titleSmall,
                    text: "${_localizations.remainingDays}: ",
                    children: [
                      TextSpan(
                        text: _remainingDays.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.blue.shade800),
              foregroundColor: const MaterialStatePropertyAll(Colors.white)),
          child: Text(_localizations.extend),
        ),
      )
    ];
  }

  List<Widget> _middleSectionWidgets() {
    if (_selectedServer == null) {
      Future.delayed(const Duration(seconds: 3), () {
        _settingsProvider.setSelectedServer(const ServerInfo(
            address: "1.waw.pl.ngexits.geph.io",
            plus: false,
            p2pAllowed: true));
      });

      return [Text("${_localizations.useAutomatic}...")];
    } else {
      final plusChip = Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.purpleAccent,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Text(
            _localizations.plusServer,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 16,
                  color: Colors.purpleAccent,
                ),
          ),
        ),
      );

      final freeChip = Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.green,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Text(
            _localizations.freeServer,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 16,
                  color: Colors.green,
                ),
          ),
        ),
      );

      final p2pYesChip = Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.green,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Text(
            _localizations.p2pYes,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 16,
                  color: Colors.green,
                ),
          ),
        ),
      );

      final p2pNoChip = Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Text(
            _localizations.p2pNo,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 16,
                  color: Colors.red,
                ),
          ),
        ),
      );

      final serverPremiumStatusChip =
          _selectedServer!.plus ? plusChip : freeChip;
      final serverP2PStatusChip =
          _selectedServer!.p2pAllowed ? p2pYesChip : p2pNoChip;

      return [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.public_rounded,
              color: _settingsProvider.serviceState == ServiceState.connected
                  ? Colors.green
                  : Colors.red,
            ),
            const SizedBox(width: 4),
            Text(
              _settingsProvider.serviceState == ServiceState.connected
                  ? _localizations.connected.toUpperCase()
                  : _localizations.disconnect.toUpperCase(),
              style: TextStyle(
                  color:
                      _settingsProvider.serviceState == ServiceState.connected
                          ? Colors.green
                          : Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        RichText(
          text: TextSpan(
            text: h.extractCountry(_selectedServer!.address)?.toUpperCase(),
            style: const TextStyle(color: Colors.grey, fontSize: 32),
            children: [
              TextSpan(
                  text:
                      " / ${_localizedCity[h.extractCity(_selectedServer!.address)]}",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground))
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 24,
              height: 16,
              child: Flag.fromString(
                h.extractCountry(_selectedServer!.address).toString(),
                borderRadius: 4,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              _selectedServer!.address,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: 20,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            serverPremiumStatusChip,
            const SizedBox(width: 8),
            serverP2PStatusChip,
          ],
        ),
      ];
    }
  }

  List<Widget> _bottomSectionWidgets() {
    return [
      if (_settingsProvider.serviceState == ServiceState.disconnected)
        SizedBox(
          width: 200,
          child: OutlinedButton(
            onPressed: () async {
              //TODO: Fetch servers here
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (_) =>
                      LoadingDialog(title: _localizations.loadingServerList));

              final List<ServerInfo> servers = await Future.delayed(
                  const Duration(seconds: 2),
                  () => [
                        const ServerInfo(
                            address: "cz-prg-101.geph.io",
                            plus: true,
                            p2pAllowed: true,
                            rating: 20),
                        const ServerInfo(
                            address: "1.ams.nl.ngexits.geph.io",
                            plus: false,
                            p2pAllowed: true,
                            rating: 90),
                        const ServerInfo(
                            address: "2.waw.pl.ngexits.geph.io",
                            plus: false,
                            p2pAllowed: true,
                            rating: 60),
                      ]);

              if (!context.mounted) return;
              Navigator.pop(context);

              final ServerInfo? selectedExit = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ServerSelectionRoute(
                            servers: servers,
                          )));

              if (!context.mounted || selectedExit == null) {
                return;
              }
              _settingsProvider.setSelectedServer(selectedExit);
            },
            child: Text(_localizations.changeLocation),
          ),
        ),
      const SizedBox(height: 8),
      if (_settingsProvider.serviceState == ServiceState.disconnected)
        SizedBox(
          width: 200,
          child: ElevatedButton(
            onPressed: () async {
              if (_selectedServer == null) return;
              await ConnectionManager.connect(context);
            },
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.green),
                foregroundColor: MaterialStatePropertyAll(Colors.white)),
            child: Text(_localizations.connect),
          ),
        ),
      if (_settingsProvider.serviceState == ServiceState.connected)
        SizedBox(
          width: 200,
          child: ElevatedButton(
            onPressed: () async {
              if (_selectedServer == null) return;
              await ConnectionManager.disconnect(context);
            },
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.red),
                foregroundColor: MaterialStatePropertyAll(Colors.white)),
            child: Text(_localizations.disconnect),
          ),
        ),
    ];
  }
}
