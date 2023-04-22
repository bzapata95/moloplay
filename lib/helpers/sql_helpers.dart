import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

import '../models/transaction.dart';

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
    await database.execute("""
      CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        type TEXT NOT NULL,
        amount DECIMAL(20,10) NOT NULL,
        createAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        personId INTEGER NOT NULL,
        FOREIGN KEY (personId) REFERENCES persons (id) ON DELETE CASCADE ON UPDATE CASCADE
      )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('moloplay.db', version: 2,
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

  static Future<int> createTransaction({
    required int personId,
    required TypeTransaction type,
    required double amount,
  }) async {
    final db = await SQLHelper.db();

    final data = {
      'personId': personId,
      'type': type == TypeTransaction.give ? 'GIVE' : 'RECEIVE',
      'amount': amount,
    };
    final id = await db.insert(
      'transactions',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    return id;
  }
}
