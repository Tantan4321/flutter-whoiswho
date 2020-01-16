import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/material.dart';
import 'package:flutter_whoiswho/game_framework.dart';

class LoadedData {
  String jsonData;

  LoadedData(this.jsonData);

  factory LoadedData.fromJson(Map<String, dynamic> parsedJson) {
    return LoadedData(parsedJson["famous_people"]);
  }

  String getData(){
    return this.jsonData;
  }
}

Future<String> _loadJsonAsset() async {
  return await rootBundle.loadString('assets/data.json');
}

Future<LoadedData> loadJson() async {
  String jsonString = await _loadJsonAsset();
  final jsonResponse = json.decode(jsonString);
  return LoadedData.fromJson(jsonResponse);
}

Future wait(int seconds) {
  return new Future.delayed(Duration(seconds: seconds), () => {});
}

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
  LoadedData data;
  bool loaded = false;
  Game game;
  List<Individual> firstFew;

  @override
  void initState() {
    super.initState();
    loadJson().then((d) => setState(() {
          print(d);
          data = d;
          loaded = true;
        }));
  }

  startGame() {
    game = Game(data.getData());

    firstFew = game.getFirstFew(3);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text('Who is Who'),
        ),
        body: loaded
            ? Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
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
              )
            : new Center(
                child: new CircularProgressIndicator(),
              ),
      floatingActionButton: loaded ? FloatingActionButton(onPressed: startGame): FloatingActionButton(onPressed: null)
    );
  }

  Image loadImage(String path) {
    return Image(image: AssetImage(path));
  }
}
