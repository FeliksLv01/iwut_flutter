import 'package:iwut_flutter/dao/course_dao.dart';
import 'package:iwut_flutter/database/database.dart';

final dbService = DBService();

class DBService {
  Future<CourseDao> getCourseDao() async {
    final dataBase = await $FloorAppDatabase.databaseBuilder('iwhut.db').build();
    return dataBase.courseDao;
  }
}
