import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geph_fgui/rss/rss_manager.dart';

void main() {
  testWidgets("dialog's widgets are as expected", (widgetTester) async {
    late String rssFileString;
    late String rssOutput;

    final bodyWidget = MaterialApp(
      home: Builder(builder: (context) {
        return Scaffold(
          body: ElevatedButton(
            onPressed: () async {
              rssFileString = await DefaultAssetBundle.of(context)
                  .loadString("assets/mock.xml");
              rssOutput = await RssManager.getRss(context);
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

    expect(rssFileString, rssOutput);
  });
}
