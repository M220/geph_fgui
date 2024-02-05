import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geph_fgui/widgets/theme_mode_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  group("ThemeMode Dialog", () {
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
      await widgetTester.pump();

      final findAlertDialog = find.byType(AlertDialog);
      final findTitle = find.text(localizations.chooseYourTheme);
      final findSingleChildScrollView = find.byType(SingleChildScrollView);
      final findColumn = find.byType(Column);
      final findRadioListTile = find.byType(RadioListTile<ThemeMode>);
      final findSystemTile = find.byWidgetPredicate((widget) =>
          widget is RadioListTile &&
          widget.value == ThemeMode.system &&
          widget.title is Text &&
          widget.checked == true);
      final findSystemTileTitle = find.text(localizations.system);
      final findLightTile = find.byWidgetPredicate((widget) =>
          widget is RadioListTile &&
          widget.value == ThemeMode.light &&
          widget.title is Text);
      final findLightTileTitle = find.text(localizations.light);
      final findDarkTile = find.byWidgetPredicate((widget) =>
          widget is RadioListTile &&
          widget.value == ThemeMode.dark &&
          widget.title is Text);
      final findDarkTileTitle = find.text(localizations.dark);
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
          findsExactly(3));
      expect(findSystemTile, findsOne);
      expect(findSystemTileTitle, findsOne);
      expect(findLightTile, findsOne);
      expect(findLightTileTitle, findsOne);
      expect(findDarkTile, findsOne);
      expect(findDarkTileTitle, findsOne);
      expect(findTextButton, findsExactly(2));
      expect(findOkButton, findsOne);
      expect(findCancelButton, findsOne);
      expect(
          widgetTester.widget<AlertDialog>(findAlertDialog).actions!.length, 2);
    });

    testWidgets("return values are correct", (widgetTester) async {
      late AppLocalizations localizations;
      ThemeMode? selectedThemeMode;

      final bodyWidget = MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(builder: (context) {
          return Scaffold(
            body: ElevatedButton(
              onPressed: () async {
                localizations = AppLocalizations.of(context)!;
                selectedThemeMode = await showDialog<ThemeMode?>(
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
      await widgetTester.pump();

      final findSystemTile = find.byWidgetPredicate((widget) =>
          widget is RadioListTile &&
          widget.value == ThemeMode.system &&
          widget.title is Text);
      final findLightTile = find.byWidgetPredicate((widget) =>
          widget is RadioListTile &&
          widget.value == ThemeMode.light &&
          widget.title is Text);
      final findDarkTile = find.byWidgetPredicate((widget) =>
          widget is RadioListTile &&
          widget.value == ThemeMode.dark &&
          widget.title is Text);

      final findOkButton = find.widgetWithText(TextButton, localizations.ok);
      final findCancelButton =
          find.widgetWithText(TextButton, localizations.cancel);

      // Cancel returns nothing.
      await widgetTester.tap(findCancelButton);
      await widgetTester.pumpAndSettle();

      expect(selectedThemeMode, null);

      // Dismiss returns nothing
      await widgetTester.tap(find.byType(ElevatedButton));
      await widgetTester.pump();
      await widgetTester.tapAt(widgetTester
          .getTopLeft(find.byWidget(bodyWidget, skipOffstage: false)));
      await widgetTester.pumpAndSettle();

      expect(selectedThemeMode, null);

      // ThemeMode.system is default
      await widgetTester.tap(find.byType(ElevatedButton));
      await widgetTester.pump();

      await widgetTester.tap(findOkButton);
      await widgetTester.pumpAndSettle();

      expect(selectedThemeMode, ThemeMode.system);

      // ThemeMode.system is returned by selection
      await widgetTester.tap(find.byType(ElevatedButton));
      await widgetTester.pump();

      await widgetTester.tap(findLightTile);
      await widgetTester.pump();
      await widgetTester.tap(findSystemTile);
      await widgetTester.pump();
      await widgetTester.tap(findOkButton);
      await widgetTester.pumpAndSettle();

      expect(selectedThemeMode, ThemeMode.system);

      // ThemeMode.light is returned by selection
      await widgetTester.tap(find.byType(ElevatedButton));
      await widgetTester.pump();

      await widgetTester.tap(findLightTile);
      await widgetTester.pump();
      await widgetTester.tap(findOkButton);
      await widgetTester.pumpAndSettle();

      expect(selectedThemeMode, ThemeMode.light);

      // ThemeMode.dark is returned by selection
      await widgetTester.tap(find.byType(ElevatedButton));
      await widgetTester.pump();

      await widgetTester.tap(findDarkTile);
      await widgetTester.pump();
      await widgetTester.tap(findOkButton);
      await widgetTester.pumpAndSettle();

      expect(selectedThemeMode, ThemeMode.dark);
    });
  });
}
