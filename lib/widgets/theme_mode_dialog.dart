import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThemeModeDialog extends StatefulWidget {
  const ThemeModeDialog({super.key, this.themeMode});

  final ThemeMode? themeMode;

  @override
  State<ThemeModeDialog> createState() => _ThemeModeDialogState();
}

class _ThemeModeDialogState extends State<ThemeModeDialog> {
  late ThemeMode selectedThemeMode = widget.themeMode ?? ThemeMode.system;
  late AppLocalizations localizations;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = AppLocalizations.of(context)!;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(localizations.chooseYourTheme),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: Text(localizations.light),
              value: ThemeMode.light,
              groupValue: selectedThemeMode,
              onChanged: setThemeModeValue,
            ),
            RadioListTile<ThemeMode>(
              title: Text(localizations.dark),
              value: ThemeMode.dark,
              groupValue: selectedThemeMode,
              onChanged: setThemeModeValue,
            ),
            RadioListTile<ThemeMode>(
              title: Text(localizations.system),
              value: ThemeMode.system,
              groupValue: selectedThemeMode,
              onChanged: setThemeModeValue,
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
          onPressed: () => Navigator.pop(context, selectedThemeMode),
          child: Text(localizations.ok),
        ),
      ],
    );
  }

  void setThemeModeValue(ThemeMode? value) {
    if (value != null) {
      setState(() {
        selectedThemeMode = value;
      });
    }
  }
}
