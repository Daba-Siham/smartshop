import 'package:flutter/material.dart';
import 'package:tp_smartshop/pages/home_page.dart';
// import 'pages/main_screen.dart';

void main() {
  runApp(const SmartShopApp());
}

class SmartShopApp extends StatelessWidget {
  const SmartShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartShop',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: HomePage(),

    );
  }
}
