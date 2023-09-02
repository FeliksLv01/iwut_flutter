import 'package:flutter/material.dart';
import 'package:iwut_flutter/config/storage_key.dart';
import 'package:iwut_flutter/global.dart';
import 'package:iwut_flutter/utils/storage_util.dart';

enum AppTheme {
  Bright,
  Dark,
  System,
}

class ThemeProvider extends ChangeNotifier {
  AppTheme? _theme;
  AppTheme? get theme {
    if (_theme == null) _theme = Global.theme;
    return _theme;
  }

  void updateTheme(AppTheme theme) {
    _theme = theme;
    StorageUtil().setInt(StorageKey.THEME, theme.index);
    notifyListeners();
  }
}
