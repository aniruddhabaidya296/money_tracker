import 'dart:ui';
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
import 'package:table_calendar/table_calendar.dart';

import '../helper/transaction_helper.dart';

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
  // List<Transaction> ultimaTarefaRemovida = [];

  var dataAtual = new DateTime.now();
  var formatter = new DateFormat('dd-MM-yyyy');
  var formatterCalendar = new DateFormat('MM-yyyy');
  String formattedDate;

  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }

  _addvalue() {
    String value = _valueController.text;
    setState(() {
      netTotal = value;
    });
  }

  _fontSize(String content) {
    if (content.length > 8) {
      return width * 0.08;
    } else {
      return width * 0.1;
    }
  }

  _salvar() {
    formattedDate = formatter.format(dataAtual);
    Transaction transaction = Transaction();
    transaction.value = 20.50;
    transaction.type = "g";
    transaction.date = "10-03-2020"; //formattedDate;
    transaction.description = "CashBack";
    TransactionHelper transactionHelper = TransactionHelper();
    transactionHelper.saveTransaction(transaction);
    transaction.toString();
  }

  _allMov() {
    transactionHelper.getAllTransaction().then((list) {
      setState(() {
        transactionList = list;
      });
      print("All Transactions: $transactionList");
    });
  }

  _allTransactionMonth(String date) {
    // customLog(transactionList.length);
    transactionHelper
        .getAllTransactionPerMonth(date: date, userId: widget.userId)
        .then((list) {
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

  @override
  void initState() {
    super.initState();
    calendarController = CalendarController();
    if (DateTime.now().month != false) {}
    //_salvar();
    formattedDate = formatterCalendar.format(dataAtual);
    print(formattedDate);
    _allTransactionMonth(formattedDate);

    //_allMov();
  }

  _dialogAddTransaction() {
    showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            userId: widget.userId,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    _allTransactionMonth(formattedDate);
    return Scaffold(
      backgroundColor: COLORS.offWhite,
      key: _scafoldKey,
      body: SingleChildScrollView(
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        //physics: ClampingScrollPhysics(),
        //height: height,
        //width: width,
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: SizeConfig.blockHeight * 6),
              width: double.infinity,
              height: height * 0.15, //300,
              color: Colors.amber,
            ),
            Column(
              children: <Widget>[
                Container(
                  width: SizeConfig.screenWidth * 0.85,
                  margin: EdgeInsets.only(
                    top: SizeConfig.blockHeight * 6,
                  ),
                  child: Container(
                    // height: height * 0.13, //150,
                    padding: EdgeInsets.only(
                      top: SizeConfig.blockHeight * 2,
                      bottom: SizeConfig.blockHeight * 4,
                    ),
                    margin: EdgeInsets.symmetric(
                      vertical: SizeConfig.blockHeight * 2,
                    ),
                    width: width * 0.1, // 70,
                    decoration: BoxDecoration(
                      color: COLORS.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[400],
                            blurRadius: 5,
                            offset: Offset(2, 2))
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.05,
                            top: width * 0.04,
                            bottom: width * 0.01,
                          ),
                          child: Text(
                            netTotal.startsWith("-")
                                ? "You owe"
                                : "You are owed",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: SizeConfig.blockWidth * 3,
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Transform.translate(
                                      offset: const Offset(2, -4),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(left: width * 0.05),
                                        child: Container(
                                          // width: width * 0.6,
                                          child: Text(
                                            "\u20b9",
                                            style: TextStyle(
                                              color: netTotal.startsWith("-")
                                                  ? Colors.red
                                                  : Colors.green,
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  SizeConfig.blockWidth * 4,
                                              //width * 0.1 //_saldoTamanho(saldoAtual)
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Text(
                                netTotal.replaceFirst('-', ''),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: netTotal.startsWith("-")
                                      ? Colors.red
                                      : Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: _fontSize(netTotal),
                                  //width * 0.1 //_saldoTamanho(saldoAtual)
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.008,
                        )
                      ],
                    ),
                  ),
                ),
                TableCalendar(
                  calendarController: calendarController,
                  locale: "en_US",
                  headerStyle: HeaderStyle(
                    formatButtonShowsNext: false,
                    formatButtonVisible: false,
                    centerHeaderTitle: true,
                  ),
                  calendarStyle: CalendarStyle(outsideDaysVisible: false),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: Colors.transparent),
                    weekendStyle: TextStyle(color: Colors.transparent),
                  ),
                  rowHeight: 0,
                  initialCalendarFormat: CalendarFormat.month,
                  onVisibleDaysChanged:
                      (dateFirst, dateLast, CalendarFormat cf) {
                    print(dateFirst);

                    formattedDate = formatterCalendar.format(dateFirst);
                    _allTransactionMonth(formattedDate);

                    print("DATE FORMATTED CALENDAR $formattedDate");
                  },
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: width * 0.04, right: width * 0.04),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Transactions",
                        style: TextStyle(
                            color: Colors.grey[600], fontSize: width * 0.04),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: width * 0.04),
                        child: GestureDetector(
                          onTap: () {
                            _dialogAddTransaction();
                            /* Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddReceita()));
                                 */
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
                                    offset: Offset(2, 2),
                                  )
                                ]),
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
                Padding(
                  padding: EdgeInsets.only(
                      left: width * 0.04, right: width * 0.04, top: 0),
                  child: SizedBox(
                    width: width,
                    height: height * 0.47,
                    child: ListView.builder(
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
                                },
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            // _scafoldKey.currentState.showSnackBar(snackBar);
                          },
                          key: ValueKey(transaction.id),
                          background: Container(
                            padding:
                                EdgeInsets.only(right: 10, top: width * 0.04),
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
                            lastItem:
                                transactionList[index] == transactionList.last
                                    ? true
                                    : false,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.only(top: 20),
                //   child: Text("EEEEEEEEE"),
                // )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
