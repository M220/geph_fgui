import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/settings_provider.dart';

class RoutingModeDialog extends StatefulWidget {
  const RoutingModeDialog({super.key, this.routingMode});

  final RoutingMode? routingMode;

  @override
  State<RoutingModeDialog> createState() => _RoutingModeDialogState();
}

class _RoutingModeDialogState extends State<RoutingModeDialog> {
  late RoutingMode selectedRoutingMode = widget.routingMode ?? RoutingMode.auto;
  late AppLocalizations localizations;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = AppLocalizations.of(context)!;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(localizations.chooseRoutingMode),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<RoutingMode>(
              title: Text(localizations.automatic.capitalize),
              value: RoutingMode.auto,
              groupValue: selectedRoutingMode,
              onChanged: setRoutingModeValue,
            ),
            RadioListTile<RoutingMode>(
              title: Text(localizations.forceBridges),
              value: RoutingMode.bridges,
              groupValue: selectedRoutingMode,
              onChanged: setRoutingModeValue,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(localizations.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, selectedRoutingMode),
          child: Text(localizations.ok),
        ),
      ],
    );
  }

  void setRoutingModeValue(RoutingMode? value) {
    if (value != null) {
      setState(() {
        selectedRoutingMode = value;
      });
    }
  }
}
