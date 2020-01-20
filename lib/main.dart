import 'package:flutter/material.dart';
import 'package:flutter_whoiswho/game_framework.dart';
import 'package:flutter_whoiswho/ui/AppColors.dart';
import 'package:flutter_whoiswho/ui/game_screen.dart';
import 'package:flutter_whoiswho/ui/launch_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 10.0,
          backgroundColor: AppColors.prussianBlue,
          title: Text('Who is Who'),
        ),
        backgroundColor: Colors.white,
        body: LaunchScreen()
    );
  }
}
