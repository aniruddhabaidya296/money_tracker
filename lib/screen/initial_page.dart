import 'package:money_tracker/Helper/transaction_helper.dart';
import 'package:money_tracker/components/animated_bottom_nav_bar.dart';
import 'package:money_tracker/components/card_transaction_item.dart';
import 'package:money_tracker/screen/taken.dart';
import 'package:money_tracker/screen/home_page.dart';
import 'package:money_tracker/screen/given.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:table_calendar/table_calendar.dart';

import '../constants/custom_log.dart';

class InitialPage extends StatefulWidget {
  final String userId;
  InitialPage({Key key, this.userId}) : super(key: key);
  final List<BarItem> barItems = [
    BarItem(
      text: "Taken",
      iconData: Icons.remove_circle_outline,
      color: Colors.pinkAccent,
    ),
    BarItem(
      text: "Home",
      iconData: Icons.home,
      color: Colors.indigo,
    ),
    BarItem(
      text: "Given",
      iconData: Icons.add_circle_outline,
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
  int selectedBarIndex = 1;

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
            if (selectedBarIndex > 2) {
              setState(() {
                selectedBarIndex--;
              });
            }
          } else if (dis.primaryVelocity < 0) {
            //User swiped from right to left
            if (selectedBarIndex < 0) {
              setState(() {
                selectedBarIndex++;
              });
            }
          }
        },
        child: tabs[selectedBarIndex],
      ),
      bottomNavigationBar: AnimatedBottomBar(
        barItems: widget.barItems,
        animationDuration: const Duration(milliseconds: 150),
        barStyle: BarStyle(fontSize: width * 0.045, iconSize: width * 0.07),
        onBarTap: (index) {
          setState(() {
            selectedBarIndex = index;
          });
        },
      ),
    );
  }
}
