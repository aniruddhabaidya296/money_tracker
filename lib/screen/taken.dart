import 'package:money_tracker/components/timeline_item.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/constants/colors.dart';
import 'package:money_tracker/constants/size_config.dart';

import '../helper/transaction_helper.dart';

class Taken extends StatefulWidget {
  final String userId;

  const Taken({Key key, this.userId}) : super(key: key);

  @override
  _TakenState createState() => _TakenState();
}

class _TakenState extends State<Taken> {
  TransactionHelper transactionHelper = TransactionHelper();
  List<Transaction> transactionList = [];

  _allTransactionByType() {
    transactionHelper
        .getAllTransactionBytype(type: "t", userId: widget.userId)
        .then((list) {
      setState(() {
        transactionList = list;
      });
      print("All transactions: $transactionList");
    });
  }

  @override
  void initState() {
    super.initState();
    _allTransactionByType();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      // backgroundColor: Colors.redAccent.withOpacity(0.8),
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
              color: Colors.amber,
              alignment: Alignment.centerLeft,
              // child: Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              child: Container(
                // padding: EdgeInsets.only(
                //   left: width * 0.05,
                //   top: width * 0.2,
                //   bottom: width * 0.05,
                // ),
                child: Text(
                  "Taken",
                  style: TextStyle(
                      color: Colors.black, //Colors.grey[400],
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.08),
                ),
              ),
              // Column(
              //   children: [
              //     Container(
              //       // color: COLORS.red,
              //       alignment: Alignment.center,
              //       child: IconButton(
              //         onPressed: () {},
              //         icon: Icon(
              //           Icons.home,
              //           size: SizeConfig.blockWidth * 8,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              //   ],
              // ),
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
                        colorItem: Colors.red[900],
                        isLast: true,
                      );
                    } else {
                      return TimeLineItem(
                        transaction: transaction,
                        colorItem: Colors.red[900],
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
    );
  }
}
