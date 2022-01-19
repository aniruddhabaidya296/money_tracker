import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../constants/global_constants.dart';

class TransactionHelper {
  static final TransactionHelper _instance = TransactionHelper.internal();

  factory TransactionHelper() => _instance;

  TransactionHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "transaction.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute("CREATE TABLE ${GlobalConstants.transactionTABLE}(" +
          "${GlobalConstants.idColumn} INTEGER PRIMARY KEY," +
          "${GlobalConstants.userId} TEXT," +
          "${GlobalConstants.valueColumn} FLOAT," +
          "${GlobalConstants.dateColumn} TEXT," +
          "${GlobalConstants.typeColumn} TEXT," +
          "${GlobalConstants.descriptionColumn} TEXT)");
    });
  }

  Future<Transaction> saveTransaction(Transaction transaction) async {
    print("Transaction save");
    Database dbTransaction = await db;
    transaction.id = await dbTransaction.insert(
      GlobalConstants.transactionTABLE,
      transaction.toMap(),
    );
    return transaction;
  }

  Future<Transaction> getTransaction(int id) async {
    Database dbTransaction = await db;
    List<Map> maps = await dbTransaction.query(GlobalConstants.transactionTABLE,
        columns: [
          GlobalConstants.idColumn,
          GlobalConstants.userId,
          GlobalConstants.valueColumn,
          GlobalConstants.dateColumn,
          GlobalConstants.typeColumn,
          GlobalConstants.descriptionColumn
        ],
        where: "${GlobalConstants.idColumn} =?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return Transaction.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteTransaction(Transaction transaction) async {
    Database dbTransaction = await db;
    return await dbTransaction.delete(GlobalConstants.transactionTABLE,
        where: "${GlobalConstants.idColumn} =?", whereArgs: [transaction.id]);
  }

  Future<int> updateTransaction(Transaction transaction) async {
    print("Transaction update");
    print(transaction.toString());
    Database dbTransaction = await db;
    return await dbTransaction.update(
        GlobalConstants.transactionTABLE, transaction.toMap(),
        where: "${GlobalConstants.idColumn} =?", whereArgs: [transaction.id]);
  }

  Future<List> getAllTransaction() async {
    Database dbTransaction = await db;
    List listMap = await dbTransaction
        .rawQuery("SELECT * FROM ${GlobalConstants.transactionTABLE}");
    List<Transaction> listTransaction = [];

    for (Map m in listMap) {
      listTransaction.add(Transaction.fromMap(m));
    }
    return listTransaction;
  }

  Future<List> getAllTransactionPerMonth({String userId, String date}) async {
    Database dbTransaction = await db;
    List listMap = await dbTransaction.rawQuery(
        "SELECT * FROM ${GlobalConstants.transactionTABLE} WHERE ${GlobalConstants.userId}='$userId' AND ${GlobalConstants.dateColumn} LIKE '%$date%'");
    List<Transaction> listTransaction = [];

    for (Map m in listMap) {
      listTransaction.add(Transaction.fromMap(m));
    }
    return listTransaction;
  }

  Future<List> getAllTransactionOfPerson(String userId) async {
    Database dbTransaction = await db;
    List listMap = await dbTransaction.rawQuery(
        "SELECT * FROM ${GlobalConstants.transactionTABLE} WHERE ${GlobalConstants.userId} LIKE '%$userId%'");
    List<Transaction> listTransaction = [];

    for (Map m in listMap) {
      listTransaction.add(Transaction.fromMap(m));
    }
    return listTransaction;
  }

  Future<List> getAllTransactionPortype({String type, String userId}) async {
    Database dbTransaction = await db;
    List listMap = await dbTransaction.rawQuery(
        "SELECT * FROM ${GlobalConstants.transactionTABLE} WHERE ${GlobalConstants.userId}='$userId' AND ${GlobalConstants.typeColumn} ='$type' ");
    List<Transaction> listTransaction = [];

    for (Map m in listMap) {
      listTransaction.add(Transaction.fromMap(m));
    }
    return listTransaction;
  }

  Future<int> getNumber() async {
    Database dbTransaction = await db;
    return Sqflite.firstIntValue(await dbTransaction
        .rawQuery("SELECT COUNT(*) FROM ${GlobalConstants.transactionTABLE}"));
  }

  Future close() async {
    Database dbTransaction = await db;
    dbTransaction.close();
  }
}

class Transaction {
  int id;
  String date;
  double value;
  String type;
  String description;
  String userId;

  Transaction();

  Transaction.fromMap(Map map) {
    id = map[GlobalConstants.idColumn];
    userId = map[GlobalConstants.userId];
    value = map[GlobalConstants.valueColumn];
    date = map[GlobalConstants.dateColumn];
    type = map[GlobalConstants.typeColumn];
    description = map[GlobalConstants.descriptionColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      GlobalConstants.valueColumn: value,
      GlobalConstants.userId: userId,
      GlobalConstants.dateColumn: date,
      GlobalConstants.typeColumn: type,
      GlobalConstants.descriptionColumn: description,
    };
    if (id != null) {
      map[GlobalConstants.idColumn] = id;
    }
    return map;
  }

  String toString() {
    return "Transaction(id: $id, personName, $userId, value: $value, data: $date, type: $type, desc: $description, )";
  }
}
