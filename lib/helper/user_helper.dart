import 'package:money_tracker/constants/custom_log.dart';
import 'package:money_tracker/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../constants/global_constants.dart';

class UserHelper {
  static final UserHelper _instance = UserHelper.internal();

  factory UserHelper() => _instance;

  UserHelper.internal();

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
    final path = join(databasePath, "user.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
        "CREATE TABLE ${GlobalConstants.userTABLE}(" +
            "${GlobalConstants.userId} INTEGER PRIMARY KEY, " +
            "${GlobalConstants.personName} TEXT, " +
            "${GlobalConstants.netTotal} TEXT);",
      );
    });
  }

  Future<User> saveUser({User user}) async {
    customLog("User save");
    Database dbUser = await db;
    user.id = await dbUser.insert(GlobalConstants.userTABLE, user.toMap());
    return user;
  }

  Future<User> getUser(int id) async {
    Database dbUser = await db;
    List<Map> maps = await dbUser.query(GlobalConstants.userTABLE,
        columns: [
          GlobalConstants.userId,
          GlobalConstants.personName,
          GlobalConstants.netTotal,
        ],
        where: "${GlobalConstants.userId} =?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteUser(User user) async {
    Database dbUser = await db;
    return await dbUser.delete(GlobalConstants.userTABLE,
        where: "${GlobalConstants.userId} =?", whereArgs: [user.id]);
  }

  void updateUser(int userId, double netTotal) async {
    print("User update");
    User user = await getUser(userId);
    Database dbUser = await db;
    // return await dbUser.update(GlobalConstants.userTABLE, user.toMap(),
    //     where: "${GlobalConstants.userId} =?", whereArgs: [user.id]);
    await dbUser.execute(
        'UPDATE ${GlobalConstants.userTABLE} SET ${GlobalConstants.netTotal} = ?  WHERE ${GlobalConstants.userId} = $userId;',
        [netTotal]);
  }

  Future<List<User>> getAllUsers() async {
    // customLog("Getting all users..");
    Database dbUser = await db;
    List listMap =
        await dbUser.rawQuery("SELECT * FROM ${GlobalConstants.userTABLE}");

    List<User> users = [];

    for (Map m in listMap) {
      users.add(User.fromMap(m));
    }
    // customLog(users);
    return users;
  }

  // Future<List> getAllTransactionPerMonth(String data) async {
  //   Database dbTransaction = await db;
  //   List listMap = await dbTransaction.rawQuery(
  //       "SELECT * FROM $transactionTABLE WHERE $dateColumn LIKE '%$data%'");
  //   List<Transaction> listTransaction = [];

  //   for (Map m in listMap) {
  //     listTransaction.add(Transaction.fromMap(m));
  //   }
  //   return listTransaction;
  // }

  // Future<List> getAllTransactionPortype(String type) async {
  //   Database dbTransaction = await db;
  //   List listMap = await dbTransaction.rawQuery(
  //       "SELECT * FROM $transactionTABLE WHERE $typeColumn ='$type' ");
  //   List<Transaction> listTransaction = [];

  //   for (Map m in listMap) {
  //     listTransaction.add(Transaction.fromMap(m));
  //   }
  //   return listTransaction;
  // }

  Future<int> getNumber() async {
    Database dbUser = await db;
    return Sqflite.firstIntValue(await dbUser
        .rawQuery("SELECT COUNT(*) FROM ${GlobalConstants.userTABLE}"));
  }

  Future close() async {
    Database dbTransaction = await db;
    dbTransaction.close();
  }
}
