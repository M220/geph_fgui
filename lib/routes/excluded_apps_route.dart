import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExcludedAppsRoute extends StatefulWidget {
  const ExcludedAppsRoute({super.key});

  @override
  State<ExcludedAppsRoute> createState() => _ExcludedAppsRouteState();
}

class _ExcludedAppsRouteState extends State<ExcludedAppsRoute> {
  late AppLocalizations localizations;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = AppLocalizations.of(context)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.selectExcludedApps),
      ),
      body: FutureBuilder(
          future: Future.delayed(const Duration(seconds: 2), () => ""),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: 20,
                  prototypeItem: const CheckboxListTile(
                    value: true,
                    onChanged: null,
                  ),
                  itemBuilder: (context, index) {
                    return index % 2 == 0
                        ? CheckboxListTile(
                            secondary: const Icon(Icons.apple),
                            title: const Text("App 1"),
                            value: true,
                            onChanged: (value) {},
                          )
                        : CheckboxListTile(
                            secondary: const Icon(Icons.biotech),
                            title: const Text("App 2"),
                            value: false,
                            onChanged: (value) {},
                          );
                  });
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
