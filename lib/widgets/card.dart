import 'dart:ui';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whoiswho/game_framework.dart';
import 'package:flutter_whoiswho/widgets/smart_image.dart';

class WhoIsCard extends StatefulWidget {
  int position;
  final Individual individual;
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  WhoIsCard({this.individual, this.position});

  @override
  _WhoIsCardState createState() => _WhoIsCardState();

  void flip() {
    cardKey.currentState.toggleCard();
  }
}

class _WhoIsCardState extends State<WhoIsCard> with TickerProviderStateMixin {
  bool visible = false;

  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this, value: 1.0);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    if (widget.position == 0) visible = true;
    if (visible) {
      controller.reverse();
    }
    super.initState();
  }

  @override
  void didUpdateWidget(WhoIsCard oldWidget) {
    if (widget.position == 0) {
      visible = true;
    }
    if (visible) {
      controller.reverse();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FlipCard(
        key: widget.cardKey,
        flipOnTouch: false,
        back: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Stack(children: <Widget>[
            SizedBox.expand(
              ///Image layer
              child: SmartImage(widget.individual.getPath())
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
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(widget.individual.getName(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.w700)),
                      Padding(padding: EdgeInsets.only(bottom: 8.0)),
                      Text('', //TODO: add back description
                          textAlign: TextAlign.start,
                          style: TextStyle(color: Colors.white)),
                    ],
                  )),
            )
          ]),
        ),
        front: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Stack(
            children: <Widget>[
              SizedBox.expand(
                ///Image layer
                child: SmartImage(widget.individual.getPath())
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
              SizedBox.expand(

                  ///Card blur filter
                  child: FadeTransition(
                opacity: animation,
                child: Container(
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade400.withOpacity(0.8)),
                      )),
                ),
              )),
            ],
          ),
        ));
  }
}
