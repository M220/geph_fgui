import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants.dart';

class StatsRoute extends StatefulWidget {
  const StatsRoute({super.key});

  @override
  State<StatsRoute> createState() => _StatsRouteState();
}

class _StatsRouteState extends State<StatsRoute> {
  late AppLocalizations localizations;
  double downloadAmount = 0;
  double uploadAmount = 0;
  int latency = 0;
  String viaString = "0.0.0.0:0000";
  String protocolString = "_";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = AppLocalizations.of(context)!;
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
                    : constraints.maxHeight),
            child: Column(
              children: [
                _statsWidget(),
                Expanded(
                  child: _debugOutputWidget(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _statsWidget() {
    const statStyle = TextStyle(fontSize: 16);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade700),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              dense: true,
              leading: const Icon(Icons.download),
              title: Text(localizations.download),
              trailing: Text(
                "$downloadAmount MB",
                style: statStyle.copyWith(color: Colors.blue),
              ),
            ),
            ListTile(
              dense: true,
              leading: const Icon(Icons.upload),
              title: Text(localizations.upload),
              trailing: Text(
                "$uploadAmount MB",
                style: statStyle.copyWith(color: Colors.red),
              ),
            ),
            ListTile(
              dense: true,
              leading: const Icon(Icons.swap_vert),
              title: Text(localizations.latency),
              trailing: Text(
                "$latency ms",
                style: statStyle,
              ),
            ),
            ListTile(
              dense: true,
              leading: const Icon(Icons.cable),
              title: Text(localizations.via),
              trailing: Text(
                viaString,
                style: statStyle,
              ),
            ),
            ListTile(
              dense: true,
              leading: const Icon(Icons.lan),
              title: Text(localizations.protocol),
              trailing: Text(
                protocolString,
                style: statStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _debugOutputWidget() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white),
        ),
        child: ListView.builder(
          key: const PageStorageKey("Debug output"),
          padding: const EdgeInsets.all(8),
          itemCount: 100,
          itemBuilder: (context, index) {
            if (index.isEven) {
              return const Text("adasdasd");
            } else {
              return const Text("bzvzkjnas");
            }
          },
        ),
      ),
    );
  }
}
