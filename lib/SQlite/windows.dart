import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class SqlWin {
  // الدالة لتهيئة قاعدة البيانات.
  Future<Database> initDb() async {
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    var db = await databaseFactory.openDatabase('Desktop/ab.db');
    // التحقق من وجود الجدول.
    var tableExists = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='User'");
    // إذا لم يكن الجدول موجودًا، قم بإنشائه.
    if (tableExists.isEmpty) {
      await createTable(db);
    }
    return db;
  }

  // الدالة لإنشاء جدول المنتجات.
  Future<void> createTable(Database db) async {
    await db.execute('''
    CREATE TABLE "User" (
        "id" INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT,
        "name" TEXT NOT NULL,
        "email" TEXT UNIQUE NOT NULL,
        "password" TEXT NOT NULL
      )
    ''');

    await db.execute('''
    CREATE TABLE "Student" (
        "id" INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT,
        "name" TEXT NOT NULL,
        "Stage" TEXT NOT NULL,
        "Card_number" TEXT UNIQUE NOT NULL,
        "Note"  TEXT
      )
    ''');

  }


  readData(sql) async {
    Database? mydb = await initDb();
    List<Map> result = await mydb.rawQuery(sql);
    closeDb(mydb);
    return result;
  }

  insertData(sql) async {
    Database? mydb = await initDb();
    int result = await mydb.rawInsert(sql);
    closeDb(mydb);
    return result;
  }

  updateData(sql) async {
    Database? mydb = await initDb();
    int result = await mydb.rawUpdate(sql);
    closeDb(mydb);
    return result;
  }

  deletData(sql) async {
    Database? mydb = await initDb();
    int result = await mydb.rawDelete(sql);
    closeDb(mydb);
    return result;
  }

  executeQurer(sql) async{
    Database? mydb = await initDb();
    List<Map<String, Object?>> result = await mydb.rawQuery(sql);
    closeDb(mydb);
    return result;
  }

    // الدالة لإغلاق قاعدة البيانات.
  Future<void> closeDb(Database db) async {
    await db.close();
  }

}
