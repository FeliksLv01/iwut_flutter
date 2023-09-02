import 'package:flutter/material.dart';

class DetailProvider extends ChangeNotifier {
  /// 当前被激活的选择器
  int? _activeSelector;

  /// get set函数
  int? get activeSelector => _activeSelector;
  set activeSelector(int? value) => _notify(() => _activeSelector = value);

  void _notify(Function() action) {
    action();
    notifyListeners();
  }
}
