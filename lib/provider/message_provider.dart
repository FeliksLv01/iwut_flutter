import 'package:flutter/material.dart';
import 'package:iwut_flutter/model/info/push_info.dart';
import 'package:iwut_flutter/model/info/update_info.dart';

class MessageProvider extends ChangeNotifier {
  int _messageSum = 0;

  bool _versionMessage = false;
  bool _activityMessage = false;

  UpdateInfo? _updateInfo;
  PushInfo? _pushInfo;
  int get messageSum => _messageSum;
  bool get versionMessage => _versionMessage;
  bool get activityMessage => _activityMessage;
  UpdateInfo? get updateInfo => _updateInfo;
  PushInfo? get pushInfo => _pushInfo;

  set updateInfo(UpdateInfo? updateInfo) {
    _updateInfo = updateInfo;
    notifyListeners();
  }

  set pushInfo(PushInfo? pushInfo) {
    _pushInfo = pushInfo;
    notifyListeners();
  }

  void addMessage() {
    _messageSum++;
    notifyListeners();
  }

  void minusMessage() {
    _messageSum--;
    notifyListeners();
  }

  set versionMessage(bool hasNewVersion) {
    _versionMessage = hasNewVersion;
    if (hasNewVersion == true) {
      addMessage();
    } else {
      minusMessage();
    }
    notifyListeners();
  }

  set activityMessage(bool hasActivity) {
    _activityMessage = hasActivity;
    if (hasActivity == true) {
      addMessage();
    } else {
      minusMessage();
    }
    notifyListeners();
  }
}
