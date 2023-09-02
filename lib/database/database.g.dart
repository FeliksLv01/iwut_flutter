// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CourseDao? _courseDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Course` (`id` INTEGER, `name` TEXT, `teacher` TEXT, `room` TEXT, `weekStart` INTEGER, `weekEnd` INTEGER, `sectionStart` INTEGER, `sectionEnd` INTEGER, `weekDay` INTEGER, `boxColor` INTEGER, `priority` INTEGER, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CourseDao get courseDao {
    return _courseDaoInstance ??= _$CourseDao(database, changeListener);
  }
}

class _$CourseDao extends CourseDao {
  _$CourseDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _courseInsertionAdapter = InsertionAdapter(
            database,
            'Course',
            (Course item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'teacher': item.teacher,
                  'room': item.room,
                  'weekStart': item.weekStart,
                  'weekEnd': item.weekEnd,
                  'sectionStart': item.sectionStart,
                  'sectionEnd': item.sectionEnd,
                  'weekDay': item.weekDay,
                  'boxColor': item.boxColor,
                  'priority': item.priority
                },
            changeListener),
        _courseUpdateAdapter = UpdateAdapter(
            database,
            'Course',
            ['id'],
            (Course item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'teacher': item.teacher,
                  'room': item.room,
                  'weekStart': item.weekStart,
                  'weekEnd': item.weekEnd,
                  'sectionStart': item.sectionStart,
                  'sectionEnd': item.sectionEnd,
                  'weekDay': item.weekDay,
                  'boxColor': item.boxColor,
                  'priority': item.priority
                },
            changeListener),
        _courseDeletionAdapter = DeletionAdapter(
            database,
            'Course',
            ['id'],
            (Course item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'teacher': item.teacher,
                  'room': item.room,
                  'weekStart': item.weekStart,
                  'weekEnd': item.weekEnd,
                  'sectionStart': item.sectionStart,
                  'sectionEnd': item.sectionEnd,
                  'weekDay': item.weekDay,
                  'boxColor': item.boxColor,
                  'priority': item.priority
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Course> _courseInsertionAdapter;

  final UpdateAdapter<Course> _courseUpdateAdapter;

  final DeletionAdapter<Course> _courseDeletionAdapter;

  @override
  Future<List<Course>> findAllCourses() async {
    return _queryAdapter.queryList('SELECT * FROM Course',
        mapper: (Map<String, Object?> row) => Course(
            id: row['id'] as int?,
            name: row['name'] as String?,
            teacher: row['teacher'] as String?,
            room: row['room'] as String?,
            weekStart: row['weekStart'] as int?,
            weekEnd: row['weekEnd'] as int?,
            sectionStart: row['sectionStart'] as int?,
            sectionEnd: row['sectionEnd'] as int?,
            weekDay: row['weekDay'] as int?,
            boxColor: row['boxColor'] as int?,
            priority: row['priority'] as int?));
  }

  @override
  Stream<List<Course>> findAllCoursesAsStream() {
    return _queryAdapter.queryListStream('SELECT * FROM Course',
        mapper: (Map<String, Object?> row) => Course(
            id: row['id'] as int?,
            name: row['name'] as String?,
            teacher: row['teacher'] as String?,
            room: row['room'] as String?,
            weekStart: row['weekStart'] as int?,
            weekEnd: row['weekEnd'] as int?,
            sectionStart: row['sectionStart'] as int?,
            sectionEnd: row['sectionEnd'] as int?,
            weekDay: row['weekDay'] as int?,
            boxColor: row['boxColor'] as int?,
            priority: row['priority'] as int?),
        queryableName: 'Course',
        isView: false);
  }

  @override
  Future<List<Course>> findCourseById(int id) async {
    return _queryAdapter.queryList('SELECT * FROM Course WHERE id=?1',
        mapper: (Map<String, Object?> row) => Course(
            id: row['id'] as int?,
            name: row['name'] as String?,
            teacher: row['teacher'] as String?,
            room: row['room'] as String?,
            weekStart: row['weekStart'] as int?,
            weekEnd: row['weekEnd'] as int?,
            sectionStart: row['sectionStart'] as int?,
            sectionEnd: row['sectionEnd'] as int?,
            weekDay: row['weekDay'] as int?,
            boxColor: row['boxColor'] as int?,
            priority: row['priority'] as int?),
        arguments: [id]);
  }

  @override
  Future<Course?> findCourseByName(String name) async {
    return _queryAdapter.query('SELECT * FROM Course WHERE name=?1 LIMIT 1',
        mapper: (Map<String, Object?> row) => Course(
            id: row['id'] as int?,
            name: row['name'] as String?,
            teacher: row['teacher'] as String?,
            room: row['room'] as String?,
            weekStart: row['weekStart'] as int?,
            weekEnd: row['weekEnd'] as int?,
            sectionStart: row['sectionStart'] as int?,
            sectionEnd: row['sectionEnd'] as int?,
            weekDay: row['weekDay'] as int?,
            boxColor: row['boxColor'] as int?,
            priority: row['priority'] as int?),
        arguments: [name]);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('Delete from Course where 1=1');
  }

  @override
  Future<void> insertCourse(Course course) async {
    await _courseInsertionAdapter.insert(course, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertCourses(List<Course> courses) async {
    await _courseInsertionAdapter.insertList(courses, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateCourse(Course course) async {
    await _courseUpdateAdapter.update(course, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateCourses(List<Course> courses) async {
    await _courseUpdateAdapter.updateList(courses, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteCourses(List<Course> courses) {
    return _courseDeletionAdapter.deleteListAndReturnChangedRows(courses);
  }

  @override
  Future<void> deleteCourse(Course course) async {
    await _courseDeletionAdapter.delete(course);
  }
}
