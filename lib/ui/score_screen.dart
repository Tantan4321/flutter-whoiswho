import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nice_button/NiceButton.dart';

import 'game_screen.dart';

class ScoreScreen extends StatelessWidget {
  int score;

  ScoreScreen(this.score);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 10.0,
          backgroundColor: Colors.cyan,
          title: Text('Who is Who'),
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Your Score:",
                  style: TextStyle(
                      color: Colors.cyan,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 20.0),
              Text("$score",
                  style: TextStyle(
                      color: Colors.cyan,
                      fontSize: 70.0,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 30.0),
              NiceButton(
                radius: 40,
                padding: EdgeInsets.all(15),
                background: Colors.cyan,
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GameScreen(context)));
                },
                text: "Use Default Deck",
              )
            ],
          ),
        )
    );
  }
}
