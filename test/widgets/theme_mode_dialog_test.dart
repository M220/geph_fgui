import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geph_fgui/widgets/theme_mode_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  group("ThemeMode Dialog", () {
    testWidgets("dialog's widgets are as expected", (widgetTester) async {
      final bodyWidget = MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(builder: (context) {
          return Scaffold(
            body: ElevatedButton(
              onPressed: () async {
                showDialog(
                    context: context, builder: (_) => const ThemeModeDialog());
              },
              child: const Text("Hit"),
            ),
          );
        }),
      );
      await widgetTester.pumpWidget(bodyWidget);
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byType(ElevatedButton));
      await widgetTester.pumpAndSettle();

      final findAlertDialog = find.byType(AlertDialog);
      final findRadioListTile = find.byType(RadioListTile);

      expect(findAlertDialog, findsOne);
      // expect(findRadioListTile, findsExactly(3));
    });
  });
}
