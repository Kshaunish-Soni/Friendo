import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Date extends ChangeNotifier {
  DateTime _date = DateTime.now();

  subtractDate() {
    _date = _date.subtract(const Duration(days: 1));
    notifyListeners();
  }

  addDate() {
    _date = _date.add(const Duration(days: 1));
    notifyListeners();
  }

  getDate() {
    return _date;
  }

  String toString() {
    return DateFormat.yMMMd().format(_date);
  }
}