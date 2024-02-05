import 'package:flex_color_scheme/flex_color_scheme.dart'
    show FlexStringExtensions;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geph_fgui/providers/settings_provider.dart';
import 'package:geph_fgui/widgets/protocol_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  group("Protocol Dialog", () {
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
                    context: context, builder: (_) => const ProtocolDialog());
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
      final findTitle = find.text(localizations.chooseProtocol);
      final findSingleChildScrollView = find.byType(SingleChildScrollView);
      final findColumn = find.byType(Column);
      final findRadioListTile = find.byType(RadioListTile<Protocol>);
      final findAutoTile = find.byWidgetPredicate((widget) =>
          widget is RadioListTile &&
          widget.value == Protocol.auto &&
          widget.title is Text &&
          widget.checked == true);
      final findAutoTileTitle = find.text(localizations.automatic.capitalize);
      final findUdpTile = find.byWidgetPredicate((widget) =>
          widget is RadioListTile &&
          widget.value == Protocol.udp &&
          widget.title is Text);
      final findUdpTileTitle = find.text("UDP");
      final findTlsTile = find.byWidgetPredicate((widget) =>
          widget is RadioListTile &&
          widget.value == Protocol.tls &&
          widget.title is Text);
      final findTlsTileTitle = find.text("TLS");
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
      expect(findAutoTile, findsOne);
      expect(findAutoTileTitle, findsOne);
      expect(findUdpTile, findsOne);
      expect(findUdpTileTitle, findsOne);
      expect(findTlsTile, findsOne);
      expect(findTlsTileTitle, findsOne);
      expect(findTextButton, findsExactly(2));
      expect(findOkButton, findsOne);
      expect(findCancelButton, findsOne);
      expect(
          widgetTester.widget<AlertDialog>(findAlertDialog).actions!.length, 2);
    });

    testWidgets("return values are correct", (widgetTester) async {
      late AppLocalizations localizations;
      Protocol? selectedProtocol;

      final bodyWidget = MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(builder: (context) {
          return Scaffold(
            body: ElevatedButton(
              onPressed: () async {
                localizations = AppLocalizations.of(context)!;
                selectedProtocol = await showDialog<Protocol?>(
                    context: context, builder: (_) => const ProtocolDialog());
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
          widget.value == Protocol.auto &&
          widget.title is Text);

      final findUdpTile = find.byWidgetPredicate((widget) =>
          widget is RadioListTile &&
          widget.value == Protocol.udp &&
          widget.title is Text);

      final findTlsTile = find.byWidgetPredicate((widget) =>
          widget is RadioListTile &&
          widget.value == Protocol.tls &&
          widget.title is Text);

      final findOkButton = find.widgetWithText(TextButton, localizations.ok);
      final findCancelButton =
          find.widgetWithText(TextButton, localizations.cancel);

      // Cancel returns nothing.
      await widgetTester.tap(findCancelButton);
      await widgetTester.pumpAndSettle();

      expect(selectedProtocol, null);

      // Dismiss returns nothing
      await widgetTester.tap(find.byType(ElevatedButton));
      await widgetTester.pump();
      await widgetTester.tapAt(widgetTester
          .getTopLeft(find.byWidget(bodyWidget, skipOffstage: false)));
      await widgetTester.pumpAndSettle();

      expect(selectedProtocol, null);

      // Protocol.auto is default
      await widgetTester.tap(find.byType(ElevatedButton));
      await widgetTester.pump();

      await widgetTester.tap(findOkButton);
      await widgetTester.pumpAndSettle();

      expect(selectedProtocol, Protocol.auto);

      // Protocol.auto is returned by selection
      await widgetTester.tap(find.byType(ElevatedButton));
      await widgetTester.pump();

      await widgetTester.tap(findUdpTile);
      await widgetTester.pump();
      await widgetTester.tap(findAutoTile);
      await widgetTester.pump();
      await widgetTester.tap(findOkButton);
      await widgetTester.pumpAndSettle();

      expect(selectedProtocol, Protocol.auto);

      // Protocol.udp is returned by selection
      await widgetTester.tap(find.byType(ElevatedButton));
      await widgetTester.pump();

      await widgetTester.tap(findUdpTile);
      await widgetTester.pump();
      await widgetTester.tap(findOkButton);
      await widgetTester.pumpAndSettle();

      expect(selectedProtocol, Protocol.udp);

      // Protocol.tls is returned by selection
      await widgetTester.tap(find.byType(ElevatedButton));
      await widgetTester.pump();

      await widgetTester.tap(findTlsTile);
      await widgetTester.pump();
      await widgetTester.tap(findOkButton);
      await widgetTester.pumpAndSettle();

      expect(selectedProtocol, Protocol.tls);
    });
  });
}
