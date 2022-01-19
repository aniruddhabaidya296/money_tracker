import 'package:money_tracker/screen/home.dart';
import 'package:money_tracker/screen/initial_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

main() {
  initializeDateFormatting().then((_) {
    runApp(MaterialApp(
      // home: InitialPage(),
      home: Home(),
      debugShowCheckedModeBanner: false,
    ));
  });
}
