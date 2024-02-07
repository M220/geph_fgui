import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geph_fgui/widgets/loading_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  group("Loading Dialog", () {
    testWidgets("dialog's widgets are as expected", (widgetTester) async {
      const mockTitle = "Loading";

      final bodyWidget = MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(builder: (context) {
          return Scaffold(
            body: ElevatedButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (_) => const LoadingDialog(title: mockTitle));
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
      final findRow = find.byType(Row);
      final findCPI = find.byType(CircularProgressIndicator);
      final findCenter = find.byType(Center);
      final findSizedBox = find.byWidgetPredicate(
          (widget) => widget is SizedBox && widget.width == 16);
      final findTitle = find.text(mockTitle);

      expect(findAlertDialog, findsOne);
      expect(find.descendant(of: findRow, matching: findCenter), findsOne);
      expect(find.descendant(of: findCenter, matching: findCPI), findsOne);
      expect(find.descendant(of: findRow, matching: findSizedBox), findsOne);
      expect(find.descendant(of: findRow, matching: findTitle), findsOne);
      expect(widgetTester.widget<Row>(findRow).children.length, 3);
    });
  });
}
