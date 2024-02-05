import 'package:flex_color_scheme/flex_color_scheme.dart'
    show FlexStringExtensions;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geph_fgui/providers/settings_provider.dart';
import 'package:geph_fgui/widgets/routing_mode_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  group("RoutingMode Dialog", () {
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
                    builder: (_) => const RoutingModeDialog());
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
      final findTitle = find.text(localizations.chooseRoutingMode);
      final findSingleChildScrollView = find.byType(SingleChildScrollView);
      final findColumn = find.byType(Column);
      final findRadioListTile = find.byType(RadioListTile<RoutingMode>);
      final findAutoTile = find.byWidgetPredicate((widget) =>
          widget is RadioListTile &&
          widget.value == RoutingMode.auto &&
          widget.title is Text &&
          widget.checked == true);
      final findAutoTileTitle = find.text(localizations.automatic.capitalize);
      final findBridgesTile = find.byWidgetPredicate((widget) =>
          widget is RadioListTile &&
          widget.value == RoutingMode.bridges &&
          widget.title is Text);
      final findBridgesTileTitle = find.text(localizations.forceBridges);
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
          findsExactly(2));
      expect(findAutoTile, findsOne);
      expect(findAutoTileTitle, findsOne);
      expect(findBridgesTile, findsOne);
      expect(findBridgesTileTitle, findsOne);
      expect(findTextButton, findsExactly(2));
      expect(findOkButton, findsOne);
      expect(findCancelButton, findsOne);
      expect(
          widgetTester.widget<AlertDialog>(findAlertDialog).actions!.length, 2);
    });

    testWidgets("return values are correct", (widgetTester) async {
      late AppLocalizations localizations;
      RoutingMode? selectedRoutingMode;

      final bodyWidget = MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(builder: (context) {
          return Scaffold(
            body: ElevatedButton(
              onPressed: () async {
                localizations = AppLocalizations.of(context)!;
                selectedRoutingMode = await showDialog<RoutingMode?>(
                    context: context,
                    builder: (_) => const RoutingModeDialog());
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

      final findAutoTile = find.byWidgetPredicate((widget) =>
          widget is RadioListTile &&
          widget.value == RoutingMode.auto &&
          widget.title is Text);

      final findBridgesTile = find.byWidgetPredicate((widget) =>
          widget is RadioListTile &&
          widget.value == RoutingMode.bridges &&
          widget.title is Text);

      final findOkButton = find.widgetWithText(TextButton, localizations.ok);
      final findCancelButton =
          find.widgetWithText(TextButton, localizations.cancel);

      // Cancel returns nothing.
      await widgetTester.tap(findCancelButton);
      await widgetTester.pumpAndSettle();

      expect(selectedRoutingMode, null);

      // Dismiss returns nothing
      await widgetTester.tap(find.byType(ElevatedButton));
      await widgetTester.pump();
      await widgetTester.tapAt(widgetTester
          .getTopLeft(find.byWidget(bodyWidget, skipOffstage: false)));
      await widgetTester.pumpAndSettle();

      expect(selectedRoutingMode, null);

      // RoutingMode.auto is default
      await widgetTester.tap(find.byType(ElevatedButton));
      await widgetTester.pump();

      await widgetTester.tap(findOkButton);
      await widgetTester.pumpAndSettle();

      expect(selectedRoutingMode, RoutingMode.auto);

      // RoutingMode.auto is returned by selection
      await widgetTester.tap(find.byType(ElevatedButton));
      await widgetTester.pump();

      await widgetTester.tap(findBridgesTile);
      await widgetTester.pump();
      await widgetTester.tap(findAutoTile);
      await widgetTester.pump();
      await widgetTester.tap(findOkButton);
      await widgetTester.pumpAndSettle();

      expect(selectedRoutingMode, RoutingMode.auto);

      // RoutingMode.bridges is returned by selection
      await widgetTester.tap(find.byType(ElevatedButton));
      await widgetTester.pump();

      await widgetTester.tap(findBridgesTile);
      await widgetTester.pump();
      await widgetTester.tap(findOkButton);
      await widgetTester.pumpAndSettle();

      expect(selectedRoutingMode, RoutingMode.bridges);
    });
  });
}
