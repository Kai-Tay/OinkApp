import 'package:first_app/data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'main.dart';

class Database {
  var database;
  dynamic spendingToday;
  dynamic spendingMonthly;

  databaseHelper() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'transactions.db'),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE transactions(id INTEGER PRIMARY KEY, name TEXT NOT NULL, cost INT NOT NULL, type TEXT NOT NULL, date TEXT NOT NULL, month TEXT NOT NULL, year TEXT NOT NULL)");
      },
      version: 1,
    );
  }

  Future insertTransaction(Transactions transaction) async {
    databaseHelper();
    final db = await database;
    await db.insert(
      'transactions',
      transaction.toMap(),
    );
  }

  Future<List<dynamic>> viewTransactionsToday() async {
    databaseHelper();
    final db = await database;
    final List<Map<String, dynamic>> maps = await db
        .rawQuery('SELECT * FROM transactions WHERE date="$databaseDate";');
    return List.generate(maps.length, (i) {
      return Transactions(
          id: maps[i]['id'],
          name: maps[i]['name'],
          cost: maps[i]['cost'],
          type: maps[i]['type'],
          date: maps[i]['date'],
          month: maps[i]['month'],
          year: maps[i]['year']);
    });
  }

  Future<List<dynamic>> viewTransactionsMonthly() async {
    databaseHelper();
    final db = await database;
    final List<Map<String, dynamic>> maps = await db
        .rawQuery('SELECT * FROM transactions WHERE month = "$databaseMonth";');
    return List.generate(maps.length, (i) {
      return Transactions(
          id: maps[i]['id'],
          name: maps[i]['name'],
          cost: maps[i]['cost'],
          type: maps[i]['type'],
          date: maps[i]['date'],
          month: maps[i]['month'],
          year: maps[i]['year']);
    });
  }

  Future<void> deleteTransaction(int? id) async {
    databaseHelper();
    final db = await database;
    await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future viewSpendingsToday() async {
    databaseHelper();
    final db = await database;

    List spendingsTodayList = await db.rawQuery(
        'SELECT SUM(cost) FROM transactions WHERE date="$databaseDate" AND type="Expense";');

    spendingToday = await spendingsTodayList[0]["SUM(cost)"];
  }

  Future viewSpendingsMonthly() async {
    databaseHelper();
    final db = await database;

    List spendingsMonthlyList = await db.rawQuery(
        'SELECT SUM(cost) FROM transactions WHERE month="$databaseMonth" AND type="Expense";');

    spendingMonthly = await spendingsMonthlyList[0]["SUM(cost)"];
  }
}
