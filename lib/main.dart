import 'package:flutter/material.dart';
import 'welcome_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

const dYollow = Color(0xFFFFFF96);
void main() {
  runApp(const MyApp());
  storage();
}

void storage() async {
  final prefs = await SharedPreferences.getInstance();
  const counter = 2;
  await prefs.setInt('counter', counter);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tracy',
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
    );
  }
}
