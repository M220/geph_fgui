import 'package:flutter/material.dart';

class RssManager {
  /// Might throw if http fetch is not successful.
  static Future<String> getRss(BuildContext context) async {
    return Future<String>.delayed(
        const Duration(seconds: 3),
        () async =>
            await DefaultAssetBundle.of(context).loadString("assets/mock.xml"));
  }
}
