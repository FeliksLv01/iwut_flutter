import 'dart:io';

import 'package:home_widget/home_widget.dart';

class HomeWidgetUtil {
  static void updateWidget({String? name}) {
    if (Platform.isAndroid) {
      HomeWidget.updateWidget(name: name);
    }
  }
}
