import 'package:english_cart/packages/qoute_model.dart';
import 'package:english_cart/packages/quote.dart';
import 'package:english_cart/pages/control_page.dart';
import 'package:english_cart/pages/home_page.dart';
import 'package:english_cart/pages/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Quotes().getAll();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: HomePage());
  }
}
