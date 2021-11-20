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

  static Future<void> insertInDatabase({
    required String taskTitle,
    required String taskTime,
    required String taskDate,
  }) async {
    final database = await createDatabase();
    try {
      await database.transaction((txn) async {
        final value = await txn.rawInsert('INSERT INTO user_tasks(title,date,time,status) '
            'VALUES("$taskTitle","$taskDate","$taskTime","new")');
        print('$value Inserted Successfully ');
      });
    } catch (error) {
      print('Error In Inserting New Record $error');
    }
  }
}
