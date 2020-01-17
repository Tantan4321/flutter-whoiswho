import 'package:flutter/material.dart';
import 'package:flutter_whoiswho/game_framework.dart';
import 'package:flutter_whoiswho/primary_page.dart';

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
    initPlatformState();
  }

  initPlatformState() {


    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 10.0,
          backgroundColor: Colors.cyan,
          title: Text('Who is Who'),
        ),
        backgroundColor: Colors.white,
        body: HomeScreen(context)
    );
  }

  Image loadImage(String path) {
    return Image(image: AssetImage(path));
  }
}
