import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/blocs/bloc.dart';
import 'package:money_tracker/components/animated_bottom_nav_bar.dart';
import 'package:money_tracker/components/card_transaction_item.dart';
import 'package:money_tracker/components/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/constants/colors.dart';
import 'package:money_tracker/constants/custom_log.dart';
import 'package:money_tracker/constants/size_config.dart';
import 'package:money_tracker/helper/user_helper.dart';
import 'package:table_calendar/table_calendar.dart';

import '../helper/transaction_helper.dart';
import '../models/user.dart';
import 'helpers/gt_box.dart';
import 'home.dart';

class HomePage extends StatefulWidget {
  final String userId;

  const HomePage({Key key, this.userId}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String netTotal = "";
  var total;
  var width;
  var height;
  bool recDesp = false;
  final GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();
  // TransactionHelper movHelper = TransactionHelper();
  TextEditingController _valueController = TextEditingController();
  CalendarController calendarController;
  TransactionHelper transactionHelper = TransactionHelper();
  List<Transaction> transactionList = [];
  UserHelper userHelper = UserHelper();
  User user;
  var dataAtual = new DateTime.now();
  var formatter = new DateFormat('dd-MM-yyyy');
  var formatterCalendar = new DateFormat('MM-yyyy');
  String formattedDate;
  double totalGiven;
  double totalTaken;

  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }

  _fontSize(String content) {
    if (content.length > 8) {
      return width * 0.08;
    } else {
      return width * 0.1;
    }
  }

  updateUser() async {
    transactionList =
        await transactionHelper.getAllTransactionOfPerson(widget.userId);
    double netTotal = 0;
    for (var i in transactionList) {
      netTotal = netTotal + i.value;
    }
    userHelper.updateUser(int.parse(widget.userId), netTotal);
  }

  _getAllTransaction() {
    // customLog(transactionList.length);
    transactionHelper.getAllTransactionOfPerson(widget.userId).then((list) {
      if (list.isNotEmpty) {
        setState(() {
          transactionList = list;
          //total =transactionList.map((item) => item.value).reduce((a, b) => a + b);
        });
        total =
            transactionList.map((item) => item.value).reduce((a, b) => a + b);
        netTotal = format(total).toString();
      } else {
        setState(() {
          transactionList.clear();
          total = 0;
          netTotal = total.toString();
        });
      }

      //print("TOTAL: $total");
      //print("All MovMES: $transactionList");
    });
  }

  getUser() {
    userHelper.getUser(int.parse(widget.userId)).then((u) {
      setState(() {
        user = u;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    calendarController = CalendarController();
    //_salvar();
    formattedDate = formatterCalendar.format(dataAtual);
    print(formattedDate);
    _getAllTransaction();
    getUser();

    //_allMov();
  }

  _dialogAddTransaction() {
    showDialog(
      barrierColor: COLORS.blackMedium.withOpacity(0.8),
      context: context,
      builder: (context) {
        return CustomDialog(
          userId: widget.userId,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    // _allTransactions();
    _getAllTransaction();
    return Scaffold(
      backgroundColor: COLORS.offWhite,
      key: _scafoldKey,
      body: SingleChildScrollView(
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              // width: SizeConfig.screenWidth,
              padding: EdgeInsets.only(
                top: SizeConfig.blockHeight * 8,
                // left: SizeConfig.blockWidth * 4,
              ),
              // color: Colors.amber,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockWidth * 4,
                ),
                width: SizeConfig.screenWidth, // 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: SizeConfig.blockHeight * 1,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: GestureDetector(
                                onTap: () async {
                                  // Navigator.pop(context);
                                  await Navigator.pushAndRemoveUntil(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, a1, a2) {
                                        return BlocProvider(
                                          create: (context) =>
                                              UserBloc()..add(FetchAllUser()),
                                          child: Home(),
                                        );
                                      },
                                      opaque: true,
                                    ),
                                    (route) => false,
                                  );
                                },
                                child: Icon(Icons.arrow_back_ios),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: SizeConfig.blockWidth * 2),
                              alignment: Alignment.center,
                              child: Text(
                                user == null
                                    ? ''
                                    : user.personName.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: SizeConfig.blockWidth * 5,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    // Expanded(
                    //   child:
                    Container(
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            // color: Colors.red,
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Transform.translate(
                                      offset: const Offset(2, -7),
                                      child: Container(
                                        // width: width * 0.6,
                                        margin: EdgeInsets.only(right: 2),
                                        child: Text(
                                          "\u20b9",
                                          style: TextStyle(
                                            color: netTotal.startsWith("-")
                                                ? Colors.red
                                                : Colors.green,
                                            fontWeight: FontWeight.bold,
                                            fontSize: SizeConfig.blockWidth * 4,
                                            //width * 0.1 //_saldoTamanho(saldoAtual)
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Expanded(
                          // child:
                          Container(
                            // color: Colors.blue,
                            child: Text(
                              netTotal.replaceFirst('-', ''),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: netTotal.startsWith("-")
                                    ? Colors.red
                                    : Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: _fontSize(netTotal),
                              ),
                            ),
                          ),
                          // ),
                        ],
                      ),
                    ),
                    // ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockWidth * 2,
                vertical: SizeConfig.blockHeight * 2,
              ),
              child: Row(
                children: [
                  gtBox(
                    boxType: 't',
                    transactionList: transactionList,
                    context: context,
                    userId: widget.userId,
                  ),
                  gtBox(
                    boxType: 'g',
                    transactionList: transactionList,
                    context: context,
                    userId: widget.userId,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockWidth * 4,
                vertical: SizeConfig.blockHeight * 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Last Transactions",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: SizeConfig.blockWidth * 4.2,
                    ),
                  ),
                  Container(
                    child: GestureDetector(
                      onTap: () {
                        _dialogAddTransaction();
                      },
                      child: Container(
                        width: width * 0.12,
                        height: width * 0.12, //65,
                        decoration: BoxDecoration(
                          color: COLORS.deepBlue, //Colors.indigo[400],
                          borderRadius: BorderRadius.circular(
                            SizeConfig.blockWidth * 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 7,
                              offset: Offset(1, 1),
                            )
                          ],
                        ),
                        child: Icon(
                          Icons.add,
                          size: width * 0.07,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Container(
                width: width,
                // color: Colors.yellow,
                height: height * 0.47,
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockWidth * 4,
                  ),
                  itemCount: transactionList.length,
                  itemBuilder: (context, index) {
                    Transaction transaction = transactionList[index];
                    Transaction ultMov = transactionList[index];
                    return Dismissible(
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        setState(() {
                          transactionList.removeAt(index);
                        });
                        transactionHelper.deleteTransaction(transaction);
                        updateUser();
                        final snackBar = SnackBar(
                          content: Text(
                            "Transaction Deleted",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15))),
                          action: SnackBarAction(
                            label: "Undo",
                            textColor: Colors.white,
                            onPressed: () {
                              setState(() {
                                transactionList.insert(index, ultMov);
                              });
                              transactionHelper.saveTransaction(ultMov);
                              updateUser();
                            },
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        // _scafoldKey.currentState.showSnackBar(snackBar);
                      },
                      key: ValueKey(transaction.id),
                      background: Container(
                        padding: EdgeInsets.only(right: 10, top: width * 0.04),
                        alignment: Alignment.topRight,
                        // color: Colors.red,
                        child: Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: width * 0.07,
                        ),
                      ),
                      child: TransactionCard(
                        transaction: transaction,
                        lastItem: transactionList[index] == transactionList.last
                            ? true
                            : false,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        //   ],
        // ),
      ),
    );
  }
}
