import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/Helper/transaction_helper.dart';
import 'package:money_tracker/blocs/user_bloc/user_bloc.dart';
import 'package:money_tracker/components/animated_bottom_nav_bar.dart';
import 'package:money_tracker/components/card_transaction_item.dart';
import 'package:money_tracker/constants/colors.dart';
import 'package:money_tracker/screen/taken.dart';
import 'package:money_tracker/screen/home_page.dart';
import 'package:money_tracker/screen/given.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:table_calendar/table_calendar.dart';

import '../constants/custom_log.dart';
import 'home.dart';

class InitialPage extends StatefulWidget {
  final int index;
  final String userId;
  InitialPage({Key key, this.userId, this.index}) : super(key: key);
  final List<BarItem> barItems = [
    BarItem(
      text: "Taken",
      iconData: Icons.arrow_downward,
      color: Colors.pinkAccent,
    ),
    BarItem(
      text: "All",
      iconData: Icons.receipt,
      color: COLORS.deepBlue,
    ),
    BarItem(
      text: "Given",
      iconData: Icons.arrow_upward,
      color: Colors.teal,
    ),
    /*BarItem(
      text: "Search",
      iconData: Icons.search,
      color: Colors.yellow.shade900,
    ),
    */
  ];

  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  int selectedBarIndex;

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedBarIndex = widget.index == null ? 1 : widget.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        //systemNavigationBarColor: Colors.lightBlue[700], // navigation bar color
        //statusBarColor: Colors.lightBlue[700],
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        statusBarIconBrightness: Brightness.light // status bar color
        ));

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    List<Widget> tabs = [
      Taken(
        userId: widget.userId,
      ),
      HomePage(
        userId: widget.userId,
      ),
      Given(
        userId: widget.userId,
      )
    ];

    //_allMov();
    //print("\nMes atual: " + DateTime.now().month.toString());
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: (dis) {
          customLog("dis.primaryVelocity is ${dis.primaryVelocity}");
          if (dis.primaryVelocity > 0) {
            //User swiped from left to right
            customLog(
                "User swiped from left to right.Previous SI is $selectedBarIndex");
            if (selectedBarIndex > 0) {
              setState(() {
                selectedBarIndex--;
              });
            }
          } else if (dis.primaryVelocity < 0) {
            //User swiped from right to left
            customLog(
                "User swiped from right to left.Previous SI is $selectedBarIndex");

            if (selectedBarIndex < 2) {
              setState(() {
                selectedBarIndex++;
              });
            }
          }
        },
        child: tabs[selectedBarIndex],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
