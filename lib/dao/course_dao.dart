import 'package:floor/floor.dart';
import 'package:iwut_flutter/model/course/course.dart';

@dao
abstract class CourseDao {
  @Query('SELECT * FROM Course')
  Future<List<Course>> findAllCourses();
  @Query('SELECT * FROM Course')
  Stream<List<Course>> findAllCoursesAsStream();

  @Query('SELECT * FROM Course WHERE id=:id')
  Future<List<Course>> findCourseById(int id);

  @Query('SELECT * FROM Course WHERE name=:name LIMIT 1')
  Future<Course?> findCourseByName(String name);

  @insert
  Future<void> insertCourse(Course course);

  @insert
  Future<void> insertCourses(List<Course> courses);

  @delete
  Future<int> deleteCourses(List<Course> courses);
  @delete
  Future<void> deleteCourse(Course course);

  @Query('Delete from Course where 1=1')
  Future<void> deleteAll();

  @update
  Future<void> updateCourse(Course course);

  @update
  Future<void> updateCourses(List<Course> courses);
}
