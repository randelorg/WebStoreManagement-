import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_store_management/HomeAdmin.dart';
import 'package:web_store_management/HomeAttendant.dart';
import 'Pages/LoginPage/LoginPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Dellrains Store Management System',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => LoginPage(),
        '/homeAdmin': (context) => HomeAdmin(),
        '/homeAttendant': (context) => HomeAttendant(),
        '/logout': (context) => LoginPage(),
      },
    );
  }
}
