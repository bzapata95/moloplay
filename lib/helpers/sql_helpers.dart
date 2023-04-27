import 'package:flutter/foundation.dart';
import 'package:molopay/models/person.dart';
import 'package:sqflite/sqflite.dart' as sql;

import '../models/transaction.dart';

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE persons(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        urlImage TEXT NULL,
        balance DECIMAL(20,10) DEFAULT 0.0,
        createAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    """);
    await database.execute("""
      CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        type TEXT NOT NULL,
        amount DECIMAL(20,10) NOT NULL,
        description TEXT NOT NULL,
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
    required Person person,
    required TypeTransaction type,
    required double amount,
    required String description,
  }) async {
    final db = await SQLHelper.db();

    final data = {
      'personId': person.id,
      'type': type == TypeTransaction.give ? 'GIVE' : 'RECEIVE',
      'amount': amount,
      'description': description,
    };
    final id = await db.insert(
      'transactions',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );

    final update = await db.update(
        'persons',
        {
          'balance': type == TypeTransaction.give
              ? (person.balance ?? 0) + amount
              : (person.balance ?? 0) - amount,
        },
        where: "id = ?",
        whereArgs: [person.id]);

    return id;
  }

  static Future<String> sumTotalBalance() async {
    final db = await SQLHelper.db();

    final result = await db.rawQuery('SELECT sum(balance)  FROM persons');

    return result.first['sum(balance)'] != null
        ? double.parse(result.first['sum(balance)'].toString())
            .toStringAsFixed(2)
        : 0.toStringAsFixed(2);
  }

  static Future<List<Map<String, dynamic>>> getTransactions() async {
    final db = await SQLHelper.db();
    final result = await db.rawQuery(
        'SELECT *  FROM transactions  INNER JOIN persons ON transactions.personId = persons.id ORDER BY createAt DESC LIMIT 15');
    return result;
  }
}
