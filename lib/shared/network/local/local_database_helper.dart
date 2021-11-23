import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path_constructor;

abstract class LocalDBHelper {
  static Future<sql.Database> createDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    //sql.deleteDatabase(path_constructor.join(dbPath, 'todo.db'));
    final sqlDatabase = await sql.openDatabase(path_constructor.join(dbPath, 'todo.db'), version: 1,
        onCreate: (database, currentVersion) async {
      try {
        await database.execute('CREATE TABLE user_tasks'
            '(id TEXT PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)');
      } catch (error) {
        rethrow;
      }
    });
    return sqlDatabase;
  }

  static Future<void> insertInDatabase({
    required String taskId,
    required String taskTitle,
    required String taskTime,
    required String taskDate,
  }) async {
    final database = await createDatabase();
    try {
      await database.transaction((txn) async {
        await txn.rawInsert('INSERT INTO user_tasks(id,title,date,time,status) '
            'VALUES("$taskId","$taskTitle","$taskDate","$taskTime","new")');
      });
    } catch (error) {
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> fetchDataFromDatabase() async {
    try {
      final database = await createDatabase();
      return await database.rawQuery('SELECT * FROM user_tasks');
    } catch (error) {
      rethrow;
    }
  }

  static void updateData(String id, String newStatus) async {
    try {
      final database = await createDatabase();
      await database.rawUpdate('UPDATE user_tasks SET status = ? WHERE id = ?', [newStatus, id]);
    } catch (error) {
      print(error.toString());
      rethrow;
    }
  }
}
