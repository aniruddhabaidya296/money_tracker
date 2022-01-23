import 'package:flutter/material.dart';
import 'package:money_tracker/constants/colors.dart';
import 'package:money_tracker/constants/size_config.dart';
import 'package:money_tracker/helper/transaction_helper.dart';
import 'package:money_tracker/screen/given.dart';
import 'package:money_tracker/screen/home_page.dart';
import 'package:money_tracker/screen/initial_page.dart';
import 'package:money_tracker/screen/taken.dart';
import 'package:page_transition/page_transition.dart';

Widget gtBox({
  List<Transaction> transactionList,
  String boxType,
  String userId,
  BuildContext context,
}) {
  return Expanded(
    child: GestureDetector(
      onTap: () {
        if (boxType == 'g') {
          Navigator.pop(context);
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeftJoined,
              opaque: true,
              childCurrent: HomePage(
                userId: userId,
              ),
              child: InitialPage(index: 2, userId: userId),
            ),
          );
        } else {
          Navigator.pop(context);
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.leftToRightJoined,
              childCurrent: HomePage(
                userId: userId,
              ),
              opaque: true,
              child: InitialPage(index: 0, userId: userId),
            ),
            // PageRouteBuilder(
            //   pageBuilder: (context, a1, a2) =>
            //       InitialPage(index: 0, userId: userId),
            //   opaque: true,
            // ),
          );
        }
      },
      child: Container(
        alignment: Alignment.center,
        height: SizeConfig.blockHeight * 15,
        margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockWidth * 2),
        decoration: BoxDecoration(
          color: boxType == 'g' ? Colors.green[100] : Colors.red[100],
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: boxType == 'g'
                ? [Colors.green[200], Colors.green[50]]
                : [Colors.red[200], Colors.red[50]],
            stops: [0, 1],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[400],
              blurRadius: 5,
              offset: Offset(4, 4),
            )
          ],
        ),
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockWidth * 3,
          vertical: SizeConfig.blockHeight * 2,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                bottom: SizeConfig.blockHeight * 2,
              ),
              child: Text(
                boxType == 'g' ? "You paid" : "You borrowed",
                style: TextStyle(
                  color: boxType == 'g' ? Colors.green[900] : Colors.red[900],
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.blockWidth * 3,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: boxType == "g"
                              ? Colors.green[300]
                              : Colors.red[300],
                          blurRadius: 10,
                          offset: Offset(2, 3),
                        )
                      ]),
                  child: Padding(
                    padding: EdgeInsets.all(
                      SizeConfig.blockWidth * 2,
                    ),
                    child: boxType == "g"
                        ? Icon(
                            Icons.call_made_rounded,
                            color: Colors.green,
                            size: SizeConfig.blockWidth * 7,
                          )
                        : Icon(
                            Icons.call_received_rounded,
                            color: Colors.red,
                            size: SizeConfig.blockWidth * 7,
                          ),
                  ),
                ),
                Text(
                  transactionList.isNotEmpty
                      ? (transactionList
                          .map((e) => e.type == boxType ? e.value : 0)
                          .reduce((v, e) => v + e)).toString()
                      : "0",
                  style: TextStyle(
                    color: boxType == 'g' ? Colors.green[900] : Colors.red[900],
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.blockWidth * 4.3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
