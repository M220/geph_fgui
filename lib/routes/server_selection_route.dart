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
  static const plusColor = Colors.purpleAccent;
  static const freeColor = Colors.green;
  static const ratingGoodColor = Colors.greenAccent;
  static const ratingBadColor = Colors.red;
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
            _topSection(),
            const SizedBox(height: 16),
            ...widget.servers.map(_serverListTile),
            const SizedBox(height: 8),
            _bottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _topSection() {
    //TODO: Change for free users
    final topText = localizations.plusIsGreat;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(20)),
        child: Text(topText),
      ),
    );
  }

  Widget _serverListTile(ServerInfo e) {
    final country = h.extractCountry(e.address)?.toUpperCase() ?? "";
    final city = localizedCity[h.extractCity(e.address)];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Card(
        child: ListTile(
          leading: SizedBox(
              width: 24,
              height: 16,
              child: Flag.fromString(
                country,
                borderRadius: 4,
              )),
          title: Text("$country / $city"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _premiumStatusChip(e),
              if (e.rating != null) ...[
                const SizedBox(width: 8),
                _ratingStatusChip(e),
              ],
            ],
          ),
          onTap: () {
            Navigator.pop(context, e);
          },
        ),
      ),
    );
  }

  Widget _premiumStatusChip(ServerInfo e) {
    final chipColor = e.plus ? plusColor : freeColor;
    final chipText =
        e.plus ? localizations.plusServer : localizations.freeServer;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: chipColor,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Text(
          chipText,
          style: GoogleFonts.roboto().copyWith(
            fontSize: 16,
            color: chipColor,
          ),
        ),
      ),
    );
  }

  Widget _ratingStatusChip(ServerInfo e) {
    final chipColor = Color.lerp(
        ratingGoodColor, ratingBadColor, (e.rating!.toDouble() / 100))!;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: chipColor,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Row(
          children: [
            Text(
              "%${e.rating!}",
              style: GoogleFonts.roboto().copyWith(
                fontSize: 16,
                color: chipColor,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.network_cell, color: chipColor),
          ],
        ),
      ),
    );
  }

  Widget _bottomSection() {
    return CheckboxListTile(
      title: Text(localizations.showAllServers),
      value: showAllServers,
      onChanged: (value) {
        if (value == null) return;
        setState(() {
          showAllServers = value;
        });
      },
    );
  }
}
