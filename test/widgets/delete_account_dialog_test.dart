import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geph_fgui/widgets/delete_account_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  group("Delete Account Dialog", () {
    testWidgets("dialog's widgets are as expected", (widgetTester) async {
      late AppLocalizations localizations;
      final bodyWidget = MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(builder: (context) {
          return Scaffold(
            body: ElevatedButton(
              onPressed: () async {
                localizations = AppLocalizations.of(context)!;
                showDialog(
                    context: context,
                    builder: (_) => const DeleteAccountDialog());
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
      final findTitle = find.text(localizations.deleteAccount);
      final findContent = find.text(localizations.deleteAccountAreYouSure);
      final findTextButton = find.byType(TextButton);
      final findOkButton = find.widgetWithText(TextButton, localizations.ok);
      final findCancelButton =
          find.widgetWithText(TextButton, localizations.cancel);

      expect(findAlertDialog, findsOne);
      expect(findTitle, findsOne);
      expect(findContent, findsOne);
      expect(findTextButton, findsExactly(2));
      expect(findOkButton, findsOne);
      expect(findCancelButton, findsOne);
    });

    testWidgets("return values are correct", (widgetTester) async {
      late AppLocalizations localizations;
      bool? confirmed;

      final bodyWidget = MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(builder: (context) {
          return Scaffold(
            body: ElevatedButton(
              onPressed: () async {
                localizations = AppLocalizations.of(context)!;
                confirmed = await showDialog<bool?>(
                    context: context,
                    builder: (_) => const DeleteAccountDialog());
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

      final findOkButton = find.widgetWithText(TextButton, localizations.ok);
      final findCancelButton =
          find.widgetWithText(TextButton, localizations.cancel);

      // Cancel returns nothing
      await widgetTester.tap(findCancelButton);
      await widgetTester.pumpAndSettle();

      expect(confirmed, null);

      // Dismiss returns nothing
      await widgetTester.tap(find.byType(ElevatedButton));
      await widgetTester.pump();
      await widgetTester.tapAt(widgetTester
          .getTopLeft(find.byWidget(bodyWidget, skipOffstage: false)));
      await widgetTester.pumpAndSettle();

      expect(confirmed, null);

      // Ok returns true
      await widgetTester.tap(find.byType(ElevatedButton));
      await widgetTester.pump();
      await widgetTester.tap(findOkButton);
      await widgetTester.pumpAndSettle();

      expect(confirmed, true);
    });
  });
}
