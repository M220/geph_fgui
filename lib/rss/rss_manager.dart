import 'package:flutter/material.dart';

class RssManager {
  static Future<String> getRss(BuildContext context) async {
    return await DefaultAssetBundle.of(context).loadString("assets/mock.xml");
  }
}
