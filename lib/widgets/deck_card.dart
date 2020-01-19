import 'dart:ui';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whoiswho/game_framework.dart';
import 'package:flutter_whoiswho/widgets/smart_image.dart';

class WhoIsWhoCard extends StatefulWidget {
  int position;
  final Individual individual;
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  WhoIsWhoCard({this.individual, this.position});

  @override
  _WhoIsWhoCardState createState() => _WhoIsWhoCardState();

  void flip() {
    cardKey.currentState.toggleCard();
  }
}

class _WhoIsWhoCardState extends State<WhoIsWhoCard> with TickerProviderStateMixin {
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
  void didUpdateWidget(WhoIsWhoCard oldWidget) {
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
                child: SmartImage(widget.individual.getPath())),
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
                              fontSize: 30.0,
                              fontWeight: FontWeight.w700)),
                      Padding(padding: EdgeInsets.only(bottom: 12.0)),
                      widget.individual.getDescription().isNotEmpty
                          ? Text(widget.individual.getDescription(),
                              textAlign: TextAlign.start,
                              softWrap: true,
                              style: TextStyle(fontSize: 18.0, color: Colors.white))
                          : Divider(),
                      Padding(padding: EdgeInsets.only(bottom: 16.0)),
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
                  child: SmartImage(widget.individual.getPath())),
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
