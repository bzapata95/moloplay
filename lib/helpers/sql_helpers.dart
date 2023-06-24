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
        dateTransaction TEXT NOT NULL,
        personId INTEGER NOT NULL,
        FOREIGN KEY (personId) REFERENCES persons (id) ON DELETE CASCADE ON UPDATE CASCADE
      )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('moloplay.db', version: 4,
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
      limit: 25,
    );
  }

  static Future<List<Map<String, dynamic>>>
      getPersonsWithTransactionRecent() async {
    final db = await SQLHelper.db();

    final List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT p.*, t.dateTransaction as dateTransaction  FROM persons p INNER JOIN transactions t ON t.personId = p.id GROUP BY t.personId ORDER BY t.createAt DESC LIMIT 5');

    //convert
    List<Map<String, dynamic>> convert = List.from(result);
    convert.sort((a, b) => DateTime.parse(b['dateTransaction'])
        .compareTo(DateTime.parse(a['dateTransaction'])));
    print('convert: $convert');
    return convert;
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
      'dateTransaction': DateTime.now().toString(),
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

  static Future<int> updateNamePerson(
      {required String name, required int idPerson}) async {
    final db = await SQLHelper.db();
    final update = await db.update(
        'persons',
        {
          'name': name,
        },
        where: "id = ?",
        whereArgs: [idPerson]);
    return update;
  }

  static Future<int> updateUrlImagePerson(
      {required String urlImage, required int idPerson}) async {
    final db = await SQLHelper.db();
    final update = await db.update(
        'persons',
        {
          'urlImage': urlImage,
        },
        where: "id = ?",
        whereArgs: [idPerson]);
    return update;
  }

  static Future<String> sumTotalBalance() async {
    final db = await SQLHelper.db();

    final result = await db.rawQuery('SELECT sum(balance)  FROM persons');

    return result.first['sum(balance)'] != null
        ? double.parse(result.first['sum(balance)'].toString())
            .toStringAsFixed(2)
        : 0.toStringAsFixed(2);
  }

  static Future<List<Map<String, dynamic>>> getTransactions(
      {int limit = 15}) async {
    final db = await SQLHelper.db();
    final result = await db.rawQuery(
        'SELECT *  FROM transactions  INNER JOIN persons ON transactions.personId = persons.id ORDER BY createAt DESC LIMIT $limit');
    return result;
  }

  static Future<List<Map<String, dynamic>>> getTransactionsByPersonId(
      {int limit = 15, required int id}) async {
    final db = await SQLHelper.db();
    final result = await db.rawQuery(
        'SELECT *  FROM transactions  INNER JOIN persons p ON transactions.personId = p.id WHERE p.id = $id ORDER BY createAt DESC LIMIT $limit ');
    return result;
  }
}
