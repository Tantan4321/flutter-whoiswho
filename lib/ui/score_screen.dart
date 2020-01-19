import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whoiswho/ui/AppColors.dart';
import 'package:flutter_whoiswho/widgets/fade_page_route.dart';
import 'package:nice_button/NiceButton.dart';

import 'game_screen.dart';

class ScoreScreen extends StatelessWidget {
  final int score;
  final Map<String, dynamic> deckJson;


  ScoreScreen(this.score, this.deckJson);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 10.0,
          backgroundColor: AppColors.prussianBlue,
          title: Text(''),
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Your Score:",
                  style: TextStyle(
                      color: AppColors.lapisLazuli,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 20.0),
              Text("$score",
                  style: TextStyle(
                      color: AppColors.lapisLazuli,
                      fontSize: 70.0,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 30.0),
              NiceButton(
                radius: 40,
                padding: EdgeInsets.all(15),
                background: Colors.teal,
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      FadeRoute(page: GameScreen(context, deckJson)));
                },
                text: "Play Again",
              )
            ],
          ),
        )
    );
  }
}
