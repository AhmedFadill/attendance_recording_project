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
    CREATE TABLE Stage (
        "Id" INTEGER NOT NULL PRIMARY KEY,
        "Name" VARCHAR(10),
        "M_E" VARCHAR(20),
        "Groups" CHAR(2)
        )
    ''');

    await db.execute('''
    CREATE TABLE Student (
      Id INTEGER PRIMARY KEY AUTOINCREMENT,
      Name VARCHAR(50) NOT NULL,
      Stage_id INTEGER NOT NULL,
      Card_number VARCHAR(50),
      Is_delete TINYINT NOT NULL DEFAULT 0,
      Note VARCHAR(50),
      FOREIGN KEY (Stage_id) REFERENCES Stage (Id)
    )
    ''');

    await db.execute('''
    CREATE TABLE Student_absences (
      Id INTEGER PRIMARY KEY AUTOINCREMENT,
      Name_student INTEGER NOT NULL,
      Is_Present INTEGER,
      Date DATE NOT NULL,
      Note VARCHAR(50),
      Type INTEGER NOT NULL,
      FOREIGN KEY (Name_student) REFERENCES Student (Id)
    )
    ''');

    print("Table created successfully without errors");
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
 
    return result;
  }

  updateData(sql) async {
    Database? mydb = await initDb();
    int result = await mydb.rawUpdate(sql);

    return result;
  }

  deletData(sql) async {
    Database? mydb = await initDb();
    int result = await mydb.rawDelete(sql);

    return result;
  }

  executeQurer(sql) async {
    Database? mydb = await initDb();
    List<Map<String, Object?>> result = await mydb.rawQuery(sql);

    return result;
  }

  // الدالة لإغلاق قاعدة البيانات.
  Future<void> closeDb(Database db) async {
    await db.close();
  }

  Future<void> deleteDatabase1() async {
    var databaseFactory = databaseFactoryFfi;
    
    await databaseFactory.deleteDatabase('Desktop/ab.db');
    print("database deleted");
  }
}
