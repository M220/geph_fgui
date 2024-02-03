import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/settings_provider.dart';

class LanguageDialog extends StatefulWidget {
  const LanguageDialog({super.key, this.locale});

  final Locale? locale;

  @override
  State<LanguageDialog> createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<LanguageDialog> {
  late Locale? selectedLocale = widget.locale;
  late AppLocalizations localizations;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = AppLocalizations.of(context)!;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(localizations.chooseYourLanguage),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<Locale>(
              title: const Text("English"),
              value: englishLocale,
              groupValue: selectedLocale,
              onChanged: setLocaleValue,
            ),
            RadioListTile<Locale>(
              title: Text(localizations.persian),
              value: persianLocale,
              groupValue: selectedLocale,
              onChanged: setLocaleValue,
            ),
            RadioListTile<Locale>(
              title: Text(localizations.chineseCH),
              value: chineseCNLocale,
              groupValue: selectedLocale,
              onChanged: setLocaleValue,
            ),
            RadioListTile<Locale>(
              title: Text(localizations.chineseTW),
              value: chineseTWLocale,
              groupValue: selectedLocale,
              onChanged: setLocaleValue,
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
          onPressed: () => Navigator.pop(context, selectedLocale),
          child: Text(localizations.ok),
        ),
      ],
    );
  }

  void setLocaleValue(Locale? value) {
    if (value != null) {
      setState(() {
        selectedLocale = value;
      });
    }
  }
}
