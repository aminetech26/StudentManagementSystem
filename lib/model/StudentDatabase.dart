import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class StudentDatabase{

  static Database? _database;
  //to ensure database is only created once.
  Future<Database?> getDatabase() async{
    if(_database == null){
      _database = await initialiseDB();
      return _database;
    }
    else{
      return _database;
    }

  }

  int i = 0;
  Future<Database> initialiseDB() async{

    String databasePath = await getDatabasesPath();
    String path = join(databasePath,'student_management_app.db');
    print(path);
    i++;
    Database database = await openDatabase(path,onCreate: (Database db,int version) async {

      Batch batch = db.batch();
      batch.execute('''
      CREATE TABLE "students"(
      "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "fullName" TEXT NOT NULL,
      "dateOfBirth" TEXT NOT NULL,
      "phoneNumber" TEXT NOT NULL
      )
      ''');
      batch.execute('''
      CREATE TABLE "attendance"(
      "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "student_id" INTEGER NOT NULL,
      "currentDate" TEXT NOT NULL,
      "status" TEXT NOT NULL,
      FOREIGN KEY (student_id) REFERENCES students(id)
      )
      ''');
      await batch.commit();

      },version: 1,);
    return database;
  }

  readData(String sql) async{
    Database? db = await getDatabase();
    List<Map> response = await db!.rawQuery(sql);
    return response;
  }

  insertData(String sql) async{
    Database? db = await getDatabase();
    int response = await db!.rawInsert(sql);
    return response;
  }

  deleteData(String sql) async{
    Database? db = await getDatabase();
    int response = await db!.rawDelete(sql);
    return response;
  }

  updateData(String sql) async{
    Database? db = await getDatabase();
    int response = await db!.rawUpdate(sql);
    return response;
  }
  deleteDB() async{
    String databasePath = await getDatabasesPath();
    String path = join(databasePath,'student_management_app.db');
    var response = await deleteDatabase(path);
  }

}