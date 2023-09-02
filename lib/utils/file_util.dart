import 'dart:io';

import 'package:iwut_flutter/config/log/log.dart';
import 'package:path_provider/path_provider.dart';

class FileUtil {
  static const String _courseFileName = "/wutCourse.html";

  static Future<File> getCourseFile() async {
    //获取存储路径
    //Directory directory = Directory('/storage/emulated/0/Download');
    Directory directory = await getApplicationDocumentsDirectory();
    Log.debug(directory.path, tag: "存储");
    File file = File(directory.path + _courseFileName);
    return file;
  }

  static Future<String> getCourseFilePath() async {
    File file = await getCourseFile();
    return file.path;
  }

  static Future<bool> isFileExisted() async {
    File file = await getCourseFile();
    return file.existsSync();
  }

  static Future<void> deleteCourseFile() async {
    File file = await getCourseFile();
    if (await file.existsSync()) {
      file.delete();
    }
  }

  static Future<void> saveCourseFile(String contents) async {
    File file = await getCourseFile();
    if (!file.existsSync()) {
      //创建文件
      file.createSync();
    } else {
      file.writeAsStringSync("");
    }
    await file.writeAsString(contents, mode: FileMode.append, flush: true);
  }
}
