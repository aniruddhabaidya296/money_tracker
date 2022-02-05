import 'package:money_tracker/components/timeline_item.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/constants/colors.dart';
import 'package:money_tracker/constants/size_config.dart';

import '../helper/transaction_helper.dart';

class Given extends StatefulWidget {
  final String userId;

  const Given({Key key, this.userId}) : super(key: key);
  @override
  _GivenState createState() => _GivenState();
}

class _GivenState extends State<Given> {
  TransactionHelper transactionHelper = TransactionHelper();
  List<Transaction> transactionList = [];
  double totalGiven;

  _allTransactionOfType() {
    transactionHelper
        .getAllTransactionBytype(type: "g", userId: widget.userId)
        .then((list) {
      if (list.isNotEmpty) {
        setState(() {
          transactionList = list;
          totalGiven = list
              .map((e) => e.value)
              .reduce((value, element) => value + element);
        });
      }
      print("All Transaction: $transactionList");
    });
  }

  @override
  void initState() {
    super.initState();
    _allTransactionOfType();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: COLORS.offWhite,
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                left: width * 0.03,
                right: width * 0.03,
                top: width * 0.18,
                bottom: width * 0.05,
              ),
              height: height * 0.15,
              decoration: BoxDecoration(
                // color: COLORS.greenExtraLight,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.green[200], COLORS.offWhite],
                  stops: [0, 1],
                ),
              ),
              alignment: Alignment.centerLeft,
              child: Container(
                // padding: EdgeInsets.only(left: width * 0.05, top: width * 0.2),
                child: Text(
                  "Given",
                  style: TextStyle(
                    color: COLORS.deepBlue, //Colors.grey[400],
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.08,
                  ),
                ),
              ),
            ),
            Container(
              child: SizedBox(
                width: width,
                height: height * 0.74,
                child: ListView.builder(
                  padding:
                      EdgeInsets.only(left: width * 0.03, top: width * 0.1),
                  itemCount: transactionList.length,
                  itemBuilder: (context, index) {
                    List movReverse = transactionList.reversed.toList();
                    Transaction transaction = movReverse[index];

                    if (movReverse[index] == movReverse.last) {
                      return TimeLineItem(
                        transaction: transaction,
                        colorItem: COLORS.offGreen,
                        isLast: true,
                      );
                    } else {
                      return TimeLineItem(
                        transaction: transaction,
                        colorItem: COLORS.offGreen,
                        isLast: false,
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        height: SizeConfig.blockHeight * 10,
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockWidth * 8,
        ),
        decoration: BoxDecoration(
          // color: COLORS.greenExtraLight,
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.green[200], COLORS.offWhite],
            stops: [0, 0.8],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "You get :",
              style: TextStyle(
                color: Colors.black,
                fontSize: SizeConfig.blockWidth * 4.2,
              ),
            ),
            Text(
              totalGiven == null ? '0' : totalGiven.toString(),
              style: TextStyle(
                color: COLORS.offGreen,
                fontSize: width * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
