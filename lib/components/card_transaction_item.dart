import 'package:flutter/material.dart';

import '../helper/transaction_helper.dart';
import 'custom_dialog.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final bool lastItem;

  const TransactionCard({Key key, this.transaction, this.lastItem = false})
      : super(key: key);

  _dialogDelete(BuildContext context, double width) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Delete transaction?",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.lightBlue[700]),
            ),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(width * 0.050),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Text(
                      "${transaction.description}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.045,
                        color: transaction.type.toString() == "g"
                            ? Colors.green[600]
                            : Colors.red[600],
                      ),
                    ),
                  ),
                  Text(
                    "Rs ${transaction.value}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: transaction.type.toString() == "g"
                            ? Colors.green[600]
                            : Colors.red[600]),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Divider(
                    color: Colors.grey[400],
                    height: 2,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              top: width * 0.02,
                              bottom: width * 0.02,
                              left: width * 0.03,
                              right: width * 0.03),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            // color: Colors.red[700],
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "No",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: width * 0.04),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          TransactionHelper transactionHelper =
                              TransactionHelper();
                          transactionHelper.deleteTransaction(transaction);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              top: width * 0.02,
                              bottom: width * 0.02,
                              left: width * 0.03,
                              right: width * 0.03),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.red[700],
                          ),
                          child: Center(
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: width * 0.04),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  _dialogEdit(BuildContext context, double width, Transaction movimentacao) {
    print(
      movimentacao.toString(),
    );
    showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            transaction: movimentacao,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            _dialogEdit(context, width, transaction);
          },
          onLongPress: () {
            _dialogDelete(context, width);
          },
          child: Container(
            // color: Colors.blue,
            //padding: EdgeInsets.all(width * 0.005),
            width: width,
            height: height * 0.08,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[300],
                              blurRadius: 10,
                              offset: Offset(2, 3),
                            )
                          ]),
                      child: Padding(
                        padding: EdgeInsets.all(width * 0.03),
                        child: transaction.type == "g"
                            ? Icon(
                                Icons.arrow_upward,
                                color: Colors.green,
                                size: width * 0.06,
                              )
                            : Icon(
                                Icons.arrow_downward,
                                color: Colors.red,
                                size: width * 0.06,
                              ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: width * 0.03),
                      child: Container(
                        width: width * 0.4,
                        child: Text(
                          transaction.description,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: transaction.type == "g"
                                ? Colors.green[700]
                                : Colors.red[700],
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.044,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  transaction.type == "g"
                      ? "+ ${transaction.value}"
                      : " ${transaction.value}",
                  style: TextStyle(
                    color: transaction.type == "g"
                        ? Colors.green[700]
                        : Colors.red[700],
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.044,
                  ),
                ),
              ],
            ),
          ),
        ),
        lastItem == true
            ? Container(
                height: height * 0.08 / 2.5,
              )
            : Container()
      ],
    );
  }
}
