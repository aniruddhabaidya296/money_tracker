import 'package:money_tracker/components/timeline_item.dart';
import 'package:flutter/material.dart';

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

  _allMovPortype() {
    transactionHelper
        .getAllTransactionPortype(type: "t", userId: widget.userId)
        .then((list) {
      setState(() {
        transactionList = list;
      });
      print("All Mov: $transactionList");
    });
  }

  @override
  void initState() {
    super.initState();
    _allMovPortype();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.redAccent.withOpacity(0.8),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: width * 0.05, top: width * 0.2),
              child: Text(
                "Taken",
                style: TextStyle(
                    color: Colors.white, //Colors.grey[400],
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.08),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: width * 0.03, top: width * 0.08),
              child: SizedBox(
                width: width,
                height: height * 0.74,
                child: ListView.builder(
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
