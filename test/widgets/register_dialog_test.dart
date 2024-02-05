import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geph_fgui/widgets/register_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  group("Register Dialog", () {
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
                    context: context, builder: (_) => const RegisterDialog());
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
      final findTitle = find.text(localizations.register);
      final findSingleChildScrollView = find.byType(SingleChildScrollView);
      final findForm = find.byType(Form);
      final findColumn = find.byType(Column);
      final findTextFormField = find.byType(TextFormField);
      final findUsernameTitle = find.text(localizations.username);
      final findPasswordTitle = find.text(localizations.password);
      final findSizedBox = find.byWidgetPredicate(
          (widget) => widget is SizedBox && widget.height == 16);
      final findContainer = find.byType(Container);
      final findCenter = find.byType(Center);
      final findCaptchaText = find.text("Captcha goes here");
      final findCaptchaTitle = find.text(localizations.captcha);

      final findRegisterButton =
          find.widgetWithText(ElevatedButton, localizations.register);

      expect(findAlertDialog, findsOne);
      expect(findTitle, findsExactly(2));
      expect(findSingleChildScrollView, findsOne);
      expect(
          find.descendant(of: findSingleChildScrollView, matching: findColumn),
          findsOne);
      expect(find.descendant(of: findColumn, matching: findForm), findsOne);
      expect(findUsernameTitle, findsOne);
      expect(findPasswordTitle, findsOne);
      expect(findContainer, findsOne);
      expect(
          find.descendant(of: findContainer, matching: findCenter), findsOne);
      expect(
          find.descendant(of: findCenter, matching: findCaptchaText), findsOne);
      expect(findCaptchaTitle, findsOne);
      expect(findTextFormField, findsExactly(3));
      expect(findSizedBox, findsExactly(3));
      expect(
          widgetTester.widget<AlertDialog>(findAlertDialog).actions!.length, 1);
      expect(findRegisterButton, findsOne);
    });
  });
}
