import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geph_fgui/providers/settings_provider.dart';
import 'package:geph_fgui/widgets/language_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  group("Language Dialog", () {
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
                    context: context, builder: (_) => const LanguageDialog());
              },
              child: const Text("Hit"),
            ),
          );
        }),
      );

      await widgetTester.pumpWidget(bodyWidget);
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byType(ElevatedButton));
      await widgetTester.pump();

      final findAlertDialog = find.byType(AlertDialog);
      final findTitle = find.text(localizations.chooseYourLanguage);
      final findSingleChildScrollView = find.byType(SingleChildScrollView);
      final findColumn = find.byType(Column);
      final findRadioListTile = find.byType(RadioListTile<Locale>);
      final findEnglishTile = find.byWidgetPredicate((widget) =>
          widget is RadioListTile &&
          widget.value == englishLocale &&
          widget.title is Text);
      final findEnglishTileTitle = find.text(localizations.english);
      final findPersianTile = find.byWidgetPredicate((widget) =>
          widget is RadioListTile &&
          widget.value == persianLocale &&
          widget.title is Text);
      final findPersianTileTitle = find.text(localizations.persian);
      final findChineseTwTile = find.byWidgetPredicate((widget) =>
          widget is RadioListTile &&
          widget.value == chineseTWLocale &&
          widget.title is Text);
      final findChineseTwTileTitle = find.text(localizations.chineseTW);
      final findChineseCnTile = find.byWidgetPredicate((widget) =>
          widget is RadioListTile &&
          widget.value == chineseCNLocale &&
          widget.title is Text);
      final findChineseCnTileTitle = find.text(localizations.chineseCH);
      final findTextButton = find.byType(TextButton);
      final findOkButton = find.widgetWithText(TextButton, localizations.ok);
      final findCancelButton =
          find.widgetWithText(TextButton, localizations.cancel);

      expect(findAlertDialog, findsOne);
      expect(findTitle, findsOne);
      expect(
          find.descendant(
              of: findAlertDialog, matching: findSingleChildScrollView),
          findsOne);
      expect(
          find.descendant(of: findSingleChildScrollView, matching: findColumn),
          findsOne);
      expect(find.descendant(of: findColumn, matching: findRadioListTile),
          findsExactly(4));
      expect(findEnglishTile, findsOne);
      expect(findEnglishTileTitle, findsOne);
      expect(findPersianTile, findsOne);
      expect(findPersianTileTitle, findsOne);
      expect(findChineseTwTile, findsOne);
      expect(findChineseTwTileTitle, findsOne);
      expect(findChineseCnTile, findsOne);
      expect(findChineseCnTileTitle, findsOne);
      expect(findTextButton, findsExactly(2));
      expect(findOkButton, findsOne);
      expect(findCancelButton, findsOne);
      expect(
          widgetTester.widget<AlertDialog>(findAlertDialog).actions!.length, 2);
    });

    testWidgets("return values are correct", (widgetTester) async {
      late AppLocalizations localizations;
      Locale? selectedLanguage;

      final bodyWidget = MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(builder: (context) {
          return Scaffold(
            body: ElevatedButton(
              onPressed: () async {
                localizations = AppLocalizations.of(context)!;
                selectedLanguage = await showDialog<Locale?>(
                    context: context, builder: (_) => const LanguageDialog());
              },
              child: const Text("Hit"),
            ),
          );
        }),
      );

      await widgetTester.pumpWidget(bodyWidget);
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.byType(ElevatedButton));
      await widgetTester.pump();

      final findEnglishTile = find.byWidgetPredicate((widget) =>
          widget is RadioListTile &&
          widget.value == englishLocale &&
          widget.title is Text);
      final findPersianTile = find.byWidgetPredicate((widget) =>
          widget is RadioListTile &&
          widget.value == persianLocale &&
          widget.title is Text);
      final findChineseTwTile = find.byWidgetPredicate((widget) =>
          widget is RadioListTile &&
          widget.value == chineseTWLocale &&
          widget.title is Text);
      final findChineseCnTile = find.byWidgetPredicate((widget) =>
          widget is RadioListTile &&
          widget.value == chineseCNLocale &&
          widget.title is Text);

      final findOkButton = find.widgetWithText(TextButton, localizations.ok);
      final findCancelButton =
          find.widgetWithText(TextButton, localizations.cancel);

      // Cancel returns nothing.
      await widgetTester.tap(findCancelButton);
      await widgetTester.pumpAndSettle();

      expect(selectedLanguage, null);

      // Dismiss returns nothing
      await widgetTester.tap(find.byType(ElevatedButton));
      await widgetTester.pump();
      await widgetTester.tapAt(widgetTester
          .getTopLeft(find.byWidget(bodyWidget, skipOffstage: false)));
      await widgetTester.pumpAndSettle();

      expect(selectedLanguage, null);

      // English is returned by selection
      await widgetTester.tap(find.byType(ElevatedButton));
      await widgetTester.pump();

      await widgetTester.tap(findPersianTile);
      await widgetTester.pump();
      await widgetTester.tap(findEnglishTile);
      await widgetTester.pump();
      await widgetTester.tap(findOkButton);
      await widgetTester.pumpAndSettle();

      expect(selectedLanguage, englishLocale);

      // Persian is returned by selection
      await widgetTester.tap(find.byType(ElevatedButton));
      await widgetTester.pump();

      await widgetTester.tap(findPersianTile);
      await widgetTester.pump();
      await widgetTester.tap(findOkButton);
      await widgetTester.pumpAndSettle();

      expect(selectedLanguage, persianLocale);

      // Chinese TW is returned by selection
      await widgetTester.tap(find.byType(ElevatedButton));
      await widgetTester.pump();

      await widgetTester.tap(findChineseTwTile);
      await widgetTester.pump();
      await widgetTester.tap(findOkButton);
      await widgetTester.pumpAndSettle();

      expect(selectedLanguage, chineseTWLocale);

      // Chinese CN is returned by selection
      await widgetTester.tap(find.byType(ElevatedButton));
      await widgetTester.pump();

      await widgetTester.tap(findChineseCnTile);
      await widgetTester.pump();
      await widgetTester.tap(findOkButton);
      await widgetTester.pumpAndSettle();

      expect(selectedLanguage, chineseCNLocale);
    });
  });
}
