import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path_constructor;

abstract class LocalDBHelper {
  static Future<sql.Database> createDatabase() async {
    final dbPath = await sql.getDatabasesPath();

    final sqlDatabase = await sql.openDatabase(path_constructor.join(dbPath, 'todo.db'), version: 1,
        onCreate: (database, currentVersion) async {
      print('Database is Created');
      try {
        await database.execute('CREATE TABLE user_tasks'
            '(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)');
        print('Table is Created');
      } catch (error) {
        print(error.toString());
      }
    }, onOpen: (database) {
      print('Database is opened');
    });
    return sqlDatabase;
  }

  static void insertInDatabase() {}
}
