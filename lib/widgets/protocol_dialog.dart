import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/settings_provider.dart';

class ProtocolDialog extends StatefulWidget {
  const ProtocolDialog({super.key, this.protocol});

  final Protocol? protocol;

  @override
  State<ProtocolDialog> createState() => _ProtocolDialogState();
}

class _ProtocolDialogState extends State<ProtocolDialog> {
  late Protocol selectedProtocol = widget.protocol ?? Protocol.auto;
  late AppLocalizations localizations;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = AppLocalizations.of(context)!;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(localizations.chooseProtocol),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<Protocol>(
              title: Text(localizations.automatic.capitalize),
              value: Protocol.auto,
              groupValue: selectedProtocol,
              onChanged: setProtocolValue,
            ),
            RadioListTile<Protocol>(
              title: const Text("UDP"),
              value: Protocol.udp,
              groupValue: selectedProtocol,
              onChanged: setProtocolValue,
            ),
            RadioListTile<Protocol>(
              title: const Text("TLS"),
              value: Protocol.tls,
              groupValue: selectedProtocol,
              onChanged: setProtocolValue,
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
          onPressed: () => Navigator.pop(context, selectedProtocol),
          child: Text(localizations.ok),
        ),
      ],
    );
  }

  void setProtocolValue(Protocol? value) {
    if (value != null) {
      setState(() {
        selectedProtocol = value;
      });
    }
  }
}
