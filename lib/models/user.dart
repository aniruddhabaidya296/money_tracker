import 'package:money_tracker/constants/custom_log.dart';
import 'package:money_tracker/constants/global_constants.dart';

class User {
  int id;
  String personName;
  double netTotal;

  User({int id, String personName, double netTotal}) {
    this.id = id;
    this.personName = personName;
    this.netTotal = netTotal;
  }

  print() {
    customLog("id: $id, personName: $personName, netTotal: $netTotal");
  }

  User.fromMap(Map map) {
    id = map[GlobalConstants.userId];
    personName = map[GlobalConstants.personName];
    netTotal = double.tryParse(map[GlobalConstants.netTotal]);
  }

  Map toMap() {
    Map<String, dynamic> map = {
      GlobalConstants.personName: personName,
      GlobalConstants.netTotal: netTotal,
    };
    if (id != null) {
      map[GlobalConstants.userId] = id;
    }
    return map;
  }

  String toString() {
    return "User(id: $id, personName: $personName, netTotal: $netTotal )";
  }
}
