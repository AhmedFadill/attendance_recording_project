import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class SqLite {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await conect();
      return _db;
    } else {
      return _db;
    }
  }

  conect() async {
    String DataBasePath = await getDatabasesPath();
    String path = join(DataBasePath, 'test.db');
    Database Mydb = await openDatabase(path,
        onCreate: _onCreat, version: 4, onUpgrade: _onUpgrade);
    return Mydb;
  }

  _onUpgrade(Database db, int oldVersion, newVersion) async {
    await db.execute('''
      CREATE TABLE "User" (
        "id" INTEGER  NOT NULL PRIMARY KEY  AUTOINCREMENT,
        "name" TEXT NOT NULL,
        "email" TEXT UNIQUE NOT NULL,
        "password" TEXT NOT NULL
      )
    ''');
    print("function Update  =========================");
  }

  _onCreat(Database db, int version) async {
    await db.execute('''
      CREATE TABLE "User" (
        "id" INTEGER  NOT NULL PRIMARY KEY  AUTOINCREMENT,
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

    print("creat table is done ============================");
  }

  readData(sql) async {
    Database? mydb = await db;
    List<Map> result = await mydb!.rawQuery(sql);
    return result;
  }

  insertData(sql) async {
    Database? mydb = await db;
    int result = await mydb!.rawInsert(sql);
    return result;
  }

  updateData(sql) async {
    Database? mydb = await db;
    int result = await mydb!.rawUpdate(sql);
    return result;
  }

  deletData(sql) async {
    Database? mydb = await db;
    int result = await mydb!.rawDelete(sql);
    return result;
  }

  executeQurer(sql) async {
    Database? mydb = await db;
    var result = await mydb!.rawQuery(sql);
    return result;
  }

  Future<void> deleteDatabase1() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'test.db');
    await deleteDatabase(path);
    print("Database deleted.");
  }
}
