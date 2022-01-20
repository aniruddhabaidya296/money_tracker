import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/blocs/user_bloc/user_bloc.dart';
import 'package:money_tracker/screen/home.dart';
import 'package:money_tracker/screen/initial_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

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
      home: BlocProvider(
        create: (context) => UserBloc()..add(FetchAllUser()),
        child: Home(),
      ),
      debugShowCheckedModeBanner: false,
    ));
  });
}
