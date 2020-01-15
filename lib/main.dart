import 'dart:async';

import 'package:flutter/material.dart';
void main() => runApp(MyApp());

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

  initPlatformState() async {

    setState(() {
    });

  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Who is Who'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.location_on,
              color: Colors.grey,
              size: width * 0.5,
            ),
            SizedBox(height: height * 0.1),
            Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(12.0),
                  width: width * 0.4,
                  child: Text(
                    'Latitude:',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
                Expanded(
                  child: Text(
                    "yes",
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.display2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
