import 'package:flutter/material.dart';

class TransparentProvider extends ChangeNotifier {
  double _alphaMonday = 1;
  double _alphaTuesday = 1;

  double get alphaMonday => _alphaMonday;

  double get alphaTuesday => _alphaTuesday;

  set alphaMonday(double alpha) {
    _alphaMonday = alpha;
    notifyListeners();
  }

  set alphaTuesday(double alpha) {
    _alphaTuesday = alpha;
    notifyListeners();
  }
}
