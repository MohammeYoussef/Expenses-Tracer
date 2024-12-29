import 'package:exponse_tracer/models/notesmodel.dart';
import 'package:sqflite/sqflite.dart';

class DBcontroller {
  // 1. create DB
  // 2. Create Tables
  // 3. CRUD
  // 4.Queries(optional)

  // 1
  static Future<Database> intiDB() {
    return openDatabase(
      'notes3.db',
      version: 1,
      onCreate: (Database db, int version) async {
        await createdb(db);
      },
    );
  }

  // 2
  static Future<void> createdb(Database db) async {
    await db.execute('''
      CREATE TABLE note(
      id INTEGER PRIMARY KEY ,
      name TEXT ,
      amount INTEGER, 
      dateTime TEXT
      )
      ''');
  }

  Future insertNote(Notesmodel not) async {
    final db = DBcontroller.intiDB();
    db.then((dbc) => dbc.insert('note', not.tomap()));
  }

  Future updateNote(Notesmodel not) async {
    final db = DBcontroller.intiDB();
    db.then((dbc) =>
        dbc.update('note', not.tomap(), where: 'id=?', whereArgs: [not.id]));
  }

  Future deleteNote(int id) async {
    final db = DBcontroller.intiDB();
    db.then((dbc) => dbc.delete('note', where: 'id=?', whereArgs: [id]));
  }

  Future<List<Map<String, dynamic>>> selectnotes() async {
    final db = DBcontroller.intiDB();
    var notes = await db.then((dbc) => dbc.query('note'));
    return notes;
  }

  Future<int> getTotalAmount() async {
    final db = await DBcontroller.intiDB();
    final result =
        await db.rawQuery('SELECT SUM(amount) as totalAmount FROM note');
    final totalAmount =
        result.first['totalAmount'] as int; // Extract the total from the result
    return totalAmount;
  }
}
