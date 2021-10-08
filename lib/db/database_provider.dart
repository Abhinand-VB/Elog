import 'package:Elog/model/log.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseProvider {
  static const String TABLE_LOG = "log";
  static const String COLUMN_ID = "id";
  static const String COLUMN_NAME = "name";
  static const String COLUMN_PLACE = "place";
  static const String COLUMN_TIME = "time";
  static const String COLUMN_PHONE = "phone";

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;

  Future<Database> get database async {
    print("database getter called");

    if (_database != null) {
      return _database;
    }

    _database = await createDatabase();

    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'logDB.db'),
      version: 2,
      onCreate: (Database database, int version) async {
        print("Creating log table");

        await database.execute(
          "CREATE TABLE $TABLE_LOG ("
          "$COLUMN_ID INTEGER PRIMARY KEY,"
          "$COLUMN_NAME TEXT,"
          "$COLUMN_PLACE TEXT,"
          "$COLUMN_PHONE TEXT,"
              "$COLUMN_TIME TEXT"
          ")",
        );
      },
    );
  }

  Future<List<Log>> getLogs() async {
    final db = await database;

    var logs = await db
        .query(TABLE_LOG, columns: [COLUMN_ID, COLUMN_NAME, COLUMN_PLACE , COLUMN_PHONE, COLUMN_TIME]);

    List<Log> logList = List<Log>();

    logs.forEach((currentLog) {
      Log log = Log.fromMap(currentLog);

      logList.add(log);
    });

    return logList;
  }

  Future<Log> insert(Log log) async {
    final db = await database;
    log.id = await db.insert(TABLE_LOG, log.toMap());
    return log;
  }

  Future<int> delete(int id) async {
    final db = await database;

    return await db.delete(
      TABLE_LOG,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> update(Log log) async {
    final db = await database;

    return await db.update(
      TABLE_LOG,
      log.toMap(),
      where: "id = ?",
      whereArgs: [log.id],
    );
  }
}
