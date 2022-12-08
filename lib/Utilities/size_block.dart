import 'package:flutter/widgets.dart';

class SizeBlock {
  final double limitValue = 0.77;
  static double? h;
  static double? v;
  static double? vMin;

  void init(BuildContext context) {
    h = MediaQuery.of(context).size.width / 375;
    v = MediaQuery.of(context).size.height / 812;
    vMin = v;
    if (h! < limitValue)
      h = limitValue;
    if (v! < limitValue) {
      v = limitValue;
      vMin = v! - 0.11;
    }
  }
}