import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE persons(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        urlImage TEXT NULL,
        createAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('moloplay.db', version: 1,
        onCreate: (sql.Database database, int versions) async {
      await createTables(database);
    });
  }

  static Future<int> createPerson({
    required String name,
    String? urlImage,
  }) async {
    final db = await SQLHelper.db();

    final data = {
      'name': name,
      'urlImage': urlImage,
    };
    final id = await db.insert(
      'persons',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<List<Map<String, dynamic>>> getPersons() async {
    final db = await SQLHelper.db();
    return db.query(
      'persons',
      orderBy: 'createAt DESC',
      limit: 15,
    );
  }

  static Future<List<Map<String, dynamic>>> getPersonById(int id) async {
    final db = await SQLHelper.db();
    return db.query(
      'persons',
      where: "id = ?",
      whereArgs: [id],
      limit: 1,
    );
  }
}
