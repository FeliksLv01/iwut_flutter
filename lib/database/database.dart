import 'dart:async';
import 'package:floor/floor.dart';
import 'package:iwut_flutter/dao/course_dao.dart';
import 'package:iwut_flutter/model/course/course.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(version: 1, entities: [Course])
abstract class AppDatabase extends FloorDatabase {
  CourseDao get courseDao;
}
