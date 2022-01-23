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
    transactionList =
        await transactionHelper.getAllTransactionOfPerson(widget.userId);
    double netTotal = 0;
    for (var i in transactionList) {
      netTotal = netTotal + i.value;
    }
    userHelper.updateUser(int.parse(widget.userId), netTotal);
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
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(width * 0.02),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            edit == false ? "Enter details" : "Edit",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.cancel_outlined),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      content: Container(
        // decoration: BoxDecoration(color: Colors.red),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: SizeConfig.blockHeight * 2),
              child: TextField(
                controller: _controllervalue,
                maxLength: 7,
                style: TextStyle(fontSize: width * 0.05),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                cursorHeight: SizeConfig.blockHeight * 2,
                cursorColor: COLORS.black,
                maxLines: 1,
                // textAlign: TextAlign.end,
                decoration: inputDecoration(text: "Amount"),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: SizeConfig.blockHeight * 2),
              child: TextField(
                controller: _controllerDesc,
                maxLength: 20,
                style: TextStyle(fontSize: width * 0.05),
                keyboardType: TextInputType.text,
                maxLines: 1,
                cursorHeight: SizeConfig.blockHeight * 2,
                cursorColor: COLORS.black,
                textAlign: TextAlign.start,
                decoration: inputDecoration(text: "Remarks"),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: SizeConfig.blockHeight * 1,
                    right: SizeConfig.blockWidth * 7,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: <Widget>[
                          Radio(
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                            activeColor: _colorTextButtom,
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
                            padding: EdgeInsets.only(
                                left: SizeConfig.blockWidth * 1),
                            child: Text("Given"),
                          )
                        ],
                      ),
                      SizedBox(
                        width: SizeConfig.blockWidth * 2,
                      ),
                      Row(
                        children: <Widget>[
                          Radio(
                            visualDensity: VisualDensity(horizontal: -4),
                            activeColor: _colorTextButtom,
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
                            padding: EdgeInsets.only(
                                left: SizeConfig.blockWidth * 1),
                            child: Text("Taken"),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: SizeConfig.blockHeight * 1,
                  ),
                  // alignment: Alignment.centerRight,
                  child: GestureDetector(
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
                      padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.blockHeight * 1,
                        horizontal: SizeConfig.blockWidth * 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(SizeConfig.blockWidth * 1),
                        color: COLORS.deepBlue,
                      ),
                      child: Text(
                        edit == false ? "Add" : "Edit",
                        style: TextStyle(
                          color: Colors.white,
                          // fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.blockWidth * 4,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration inputDecoration({String text}) {
    return InputDecoration(
      // hintText: text,
      label: Text(text),
      labelStyle: TextStyle(
        color: COLORS.greyLight,
        fontSize: SizeConfig.blockWidth * 4,
      ),
      alignLabelWithHint: true,
      // fillColor: COLORS.white,
      counterText: "",
      //hintStyle: TextStyle(color: Colors.grey[400]),
      contentPadding: EdgeInsets.only(
          left: SizeConfig.blockWidth * 2,
          top: SizeConfig.blockWidth * 1,
          bottom: SizeConfig.blockWidth * 1,
          right: SizeConfig.blockWidth * 2),

      focusedBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(SizeConfig.blockWidth * 2),
        borderSide: BorderSide(
          color: COLORS.black,
          width: 2.0,
        ),
      ),
      enabledBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(SizeConfig.blockWidth * 2),
        borderSide: BorderSide(
          color: COLORS.greyExtraLight,
          width: 2.0,
        ),
      ),
    );
  }
}
