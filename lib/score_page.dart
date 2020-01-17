import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
//              CupertinoButton(
//                color: Colors.cyan,
//                onPressed: () {
//                  Navigator.pop(context);
//                },
//                child: Text("Play Again",
//                    style: TextStyle(
//                        color: Colors.white,
//                        fontSize: 25.0,
//                        fontWeight: FontWeight.bold)),
//              )
            ],
          ),
        )
    );
  }
}
