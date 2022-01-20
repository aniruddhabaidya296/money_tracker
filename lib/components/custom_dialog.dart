import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/blocs/user_bloc/user_bloc.dart';
import 'package:money_tracker/constants/colors.dart';
import 'package:money_tracker/constants/size_config.dart';
import 'package:money_tracker/helper/user_helper.dart';
import 'package:money_tracker/screen/home_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../helper/transaction_helper.dart';

class CustomDialog extends StatefulWidget {
  final Transaction transaction;
  final String userId;
  const CustomDialog({Key key, this.transaction, this.userId})
      : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  var formatter = new DateFormat('dd-MM-yyyy');
  bool edit;

  int _groupValueRadio = 1;
  Color _colorContainer = Colors.green[400];
  Color _colorTextButtom = Colors.green;
  TextEditingController _controllervalue = TextEditingController();
  TextEditingController _controllerDesc = TextEditingController();
  List<Transaction> transactionList = [];
  TransactionHelper transactionHelper = TransactionHelper();
  UserHelper userHelper = UserHelper();

  updateUser() async {
    await transactionHelper.getAllTransaction().then((list) {
      setState(() {
        transactionList = list;
      });
      userHelper.updateUser(
        int.parse(widget.userId),
      );
      // print("All Transactions: $transactionList");
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.transaction != null) {
      print(widget.transaction.toString());

      edit = true;
      if (widget.transaction.type == "t") {
        _groupValueRadio = 2;
        _colorContainer = Colors.red[300];
        _colorTextButtom = Colors.red[300];
      }

      _controllervalue.text =
          widget.transaction.value.toString().replaceAll("-", "");
      _controllerDesc.text = widget.transaction.description;
    } else {
      edit = false;
    }
    print(" edit -> $edit");
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(width * 0.050)),
        title: Text(
          "Amount",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  // Text(
                  //   "Rs ",
                  //   style:
                  //       TextStyle(color: Colors.white, fontSize: width * 0.06),
                  // ),
                  Flexible(
                    child: TextField(
                      controller: _controllervalue,
                      maxLength: 7,
                      style: TextStyle(fontSize: width * 0.05),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      maxLines: 1,
                      // textAlign: TextAlign.end,
                      decoration: inputDecoration(text: "Enter Amount"),
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Radio(
                    activeColor: COLORS.deepBlue,
                    value: 1,
                    groupValue: _groupValueRadio,
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        _groupValueRadio = value;
                        _colorContainer = Colors.green[400];
                        _colorTextButtom = Colors.green;
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.01),
                    child: Text("Given"),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Radio(
                    activeColor: COLORS.deepBlue,
                    value: 2,
                    groupValue: _groupValueRadio,
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        _groupValueRadio = value;
                        _colorContainer = Colors.red[300];
                        _colorTextButtom = Colors.red[300];
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.01),
                    child: Text("Taken"),
                  )
                ],
              ),
              TextField(
                controller: _controllerDesc,
                maxLength: 20,
                style: TextStyle(fontSize: width * 0.05),
                keyboardType: TextInputType.text,
                maxLines: 1,
                textAlign: TextAlign.start,
                decoration: inputDecoration(text: "Note"),
              ),
              Padding(
                padding: EdgeInsets.only(top: width * 0.09),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_controllervalue.text.isNotEmpty &&
                            _controllerDesc.text.isNotEmpty) {
                          Transaction transaction = Transaction();
                          String value;
                          if (_controllervalue.text.contains(",")) {
                            value = _controllervalue.text
                                .replaceAll(RegExp(","), ".");
                          } else {
                            value = _controllervalue.text;
                          }

                          transaction.date = formatter.format(DateTime.now());
                          transaction.description = _controllerDesc.text;
                          transaction.userId = widget.userId;
                          if (_groupValueRadio == 1) {
                            transaction.value = double.parse(value);
                            transaction.type = "g";
                            if (widget.transaction != null) {
                              transaction.id = widget.transaction.id;
                            }
                            edit == false
                                ? transactionHelper.saveTransaction(transaction)
                                : transactionHelper
                                    .updateTransaction(transaction);
                          }
                          if (_groupValueRadio == 2) {
                            transaction.value = double.parse("-" + value);
                            transaction.type = "t";
                            if (widget.transaction != null) {
                              transaction.id = widget.transaction.id;
                            }
                            edit == false
                                ? transactionHelper.saveTransaction(transaction)
                                : transactionHelper
                                    .updateTransaction(transaction);
                          }
                          updateUser();
                          Navigator.pop(context);
                          //initState();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            top: width * 0.02,
                            bottom: width * 0.02,
                            left: width * 0.03,
                            right: width * 0.03),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: COLORS.deepBlue,
                        ),
                        child: Center(
                          child: Text(
                            edit == false ? "Confirm" : "Edit",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.05),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  InputDecoration inputDecoration({String text}) {
    return InputDecoration(
      //hintText: "descrição",
      hintText: text,
      hintStyle: TextStyle(
        color: COLORS.greyLight,
        fontSize: SizeConfig.blockWidth * 4.2,
      ),
      //hintStyle: TextStyle(color: Colors.grey[400]),
      contentPadding: EdgeInsets.only(
          left: SizeConfig.blockWidth * 2,
          top: SizeConfig.blockWidth * 1,
          bottom: SizeConfig.blockWidth * 1,
          right: SizeConfig.blockWidth * 2),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeConfig.blockWidth * 2),
        borderSide: BorderSide(
          color: COLORS.deepBlue,
          width: 2.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeConfig.blockWidth * 2),
        borderSide: BorderSide(
          color: COLORS.deepBlue,
          width: 2.0,
        ),
      ),
    );
  }
}
