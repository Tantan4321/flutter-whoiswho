import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whoiswho/ui/game_screen.dart';
import 'package:nice_button/nice_button.dart';

class LaunchScreen extends StatefulWidget {
  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            NiceButton(
              radius: 40,
              padding: EdgeInsets.all(15),
              background: Colors.cyan,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GameScreen(context)));
              },
              text: "Use Default Deck",
            )
          ],
        ),
      ),
    );
  }

  void startGame(
      String
          pathToDeck) {} //TODO: pathToDeck will always be local, this screen handles the saving of local files
}
