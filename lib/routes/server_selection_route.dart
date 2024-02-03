import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helpers/address_localization_helper.dart' as h;
import '../data/server_info.dart';

class ServerSelectionRoute extends StatefulWidget {
  const ServerSelectionRoute({super.key, required this.servers});
  final List<ServerInfo> servers;

  @override
  State<ServerSelectionRoute> createState() => _ServerSelectionRouteState();
}

class _ServerSelectionRouteState extends State<ServerSelectionRoute> {
  late AppLocalizations localizations;
  late Map<String, String> localizedCity;
  bool showAllServers = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = AppLocalizations.of(context)!;
    localizedCity = h.getLocalizedCityMap(localizations);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(localizations.exitSelection)),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(20)),
                child: Text(localizations.plusIsGreat),
              ),
            ),
            const SizedBox(height: 16),
            ...widget.servers.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Card(
                  child: ListTile(
                    leading: SizedBox(
                        width: 24,
                        height: 16,
                        child: Flag.fromString(
                          h.extractCountry(e.address).toString(),
                          borderRadius: 4,
                        )),
                    title: Text(
                        "${h.extractCountry(e.address)?.toUpperCase()} / ${localizedCity[h.extractCity(e.address)]}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  e.plus ? Colors.purpleAccent : Colors.green,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            child: Text(
                              e.plus
                                  ? localizations.plusServer
                                  : localizations.freeServer,
                              style: GoogleFonts.roboto().copyWith(
                                fontSize: 16,
                                color:
                                    e.plus ? Colors.purpleAccent : Colors.green,
                              ),
                            ),
                          ),
                        ),
                        if (e.rating != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.lerp(Colors.greenAccent,
                                    Colors.red, (e.rating!.toDouble() / 100))!,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              child: Row(
                                children: [
                                  Text(
                                    "%${e.rating!.toString()}",
                                    style: GoogleFonts.roboto().copyWith(
                                      fontSize: 16,
                                      color: Color.lerp(
                                          Colors.greenAccent,
                                          Colors.red,
                                          (e.rating!.toDouble() / 100))!,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(Icons.network_cell,
                                      color: Color.lerp(
                                          Colors.greenAccent,
                                          Colors.red,
                                          (e.rating!.toDouble() / 100))!),
                                ],
                              ),
                            ),
                          )
                        ],
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context, e);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              title: Text(localizations.showAllServers),
              value: showAllServers,
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  showAllServers = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
