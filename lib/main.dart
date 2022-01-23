import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/blocs/user_bloc/user_bloc.dart';
import 'package:money_tracker/screen/home.dart';
import 'package:money_tracker/screen/initial_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:page_transition/page_transition.dart';

import 'constants/colors.dart';
import 'constants/size_config.dart';

main() {
  initializeDateFormatting().then((_) {
    runApp(MaterialApp(
      // home: InitialPage(),
      theme: ThemeData(
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoWillPopScopePageTransionsBuilder(),
          },
        ),
      ),
      home: IntroSplashScreen(),
      debugShowCheckedModeBanner: false,
    ));
  });
}

class IntroSplashScreen extends StatefulWidget {
  const IntroSplashScreen({Key key}) : super(key: key);

  @override
  _IntroSplashScreenState createState() => _IntroSplashScreenState();
}

class _IntroSplashScreenState extends State<IntroSplashScreen> {
  navigateToHomePage() {
    Future.delayed(
      Duration(seconds: 3),
      () {
        Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: BlocProvider(
              create: (context) => UserBloc()..add(FetchAllUser()),
              child: Home(),
            ),
          ),
          (route) => false,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    navigateToHomePage();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: COLORS.white,
      body: Center(
        child: AnimatedContainer(
          duration: Duration(seconds: 2),
          curve: Curves.easeIn,
          child: Container(
            alignment: Alignment.center,
            child: Image.asset("assets/mt.jpg"),
          ),
        ),
      ),
    );
  }
}
