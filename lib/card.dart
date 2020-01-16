import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_whoiswho/game_framework.dart';

class WhoIsCard extends StatefulWidget {
  bool visible = false;
  final Individual individual;

  WhoIsCard(this.individual);

  _WhoIsCardState _state = _WhoIsCardState();
  @override
  _WhoIsCardState createState() => _state;


  void makeVisible() {
    visible = true;
  }
}

class _WhoIsCardState extends State<WhoIsCard> {

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Stack(
        children: <Widget>[
          SizedBox.expand(
            ///Image layer
            child: Image.asset(widget.individual.getPath(), fit: BoxFit.cover),
          ),
          SizedBox.expand(
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black54],
                      begin: Alignment.center,
                      end: Alignment.bottomCenter)),
            ),
          ),
          Align(
            ///Text layer
            alignment: Alignment.bottomLeft,
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.individual.getName(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700)),
                    Padding(padding: EdgeInsets.only(bottom: 8.0)),
                    Text('Description.',
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.white)),
                  ],
                )),
          ),
          SizedBox.expand(
            ///Card blur filter
            child: !widget.visible ? Container(
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade400.withOpacity(0.8)),
                  )),
            ): Container()
          ),
        ],
      ),
    );
  }
}
