import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_whoiswho/ui/AppColors.dart';
import 'package:flutter_whoiswho/ui/score_screen.dart';
import 'package:flutter_whoiswho/widgets/deck_card.dart';
import 'package:flutter_whoiswho/widgets/fade_indexed_stack.dart';
import 'package:flutter_whoiswho/widgets/fade_page_route.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

import '../game_framework.dart';

List<Alignment> cardsAlign = [
  Alignment(0.0, 1.0),
  Alignment(0.0, 0.8),
  Alignment(0.0, 0.0)
];
List<Size> cardsSize = List(3);

class GameScreen extends StatefulWidget {
  final Map<String, dynamic> deckJson;

  GameScreen(BuildContext context, this.deckJson) {
    cardsSize[0] = Size(MediaQuery.of(context).size.width * 0.9,
        MediaQuery.of(context).size.height * 0.6);
    cardsSize[1] = Size(MediaQuery.of(context).size.width * 0.85,
        MediaQuery.of(context).size.height * 0.55);
    cardsSize[2] = Size(MediaQuery.of(context).size.width * 0.8,
        MediaQuery.of(context).size.height * 0.5);
  }

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  String deckName;

  Game game;
  int counter;
  bool correct;

  int _gameBarIndex = 0;
  AnimationController timer;

  String get timerString {
    Duration d = timer.duration * timer.value;
    return '${(d.inSeconds).toString()}';
  }

  List<WhoIsWhoCard> cards = List();
  AnimationController _controller;

  final Alignment defaultTopCardAlign = Alignment(0.0, 0.0);
  Alignment topCardAlign;
  double topCardRot = 0.0;

  @override
  void initState() {
    super.initState();
    //Init the game
    deckName = widget.deckJson.keys.toList()[0];
    game = new Game(widget.deckJson, deckName);
    counter = 0;
    //Get the first few cards
    List<Individual> firstFew = game.getFirstFew(cardsSize.length);

    //Init timer
    timer = AnimationController(
      value: 1.0,
      duration: Duration(seconds: 10),
      vsync: this,
    );
    timer.addListener(() => setState(() {}));
    timer.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.dismissed) timerComplete();
    });

    //Init cards
    for (int i = 0; i < firstFew.length; i++) {
      cards.add(WhoIsWhoCard(individual: firstFew[i], position: i));
    } //Make the top card visible

    topCardAlign = cardsAlign[2];

    //Init the animation controller
    _controller =
        AnimationController(duration: Duration(milliseconds: 700), vsync: this);
    _controller.addListener(() => setState(() {}));
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) refreshCards();
    });

    timer.reverse();
  }

  @override
  void dispose() {
    timer.dispose();
    _controller.dispose();
    super.dispose();
  }

  String toTitleCase(String givenString) {
    List<String> arr = givenString.split("_");
    String ret = "";
    for (int i = 0; i < arr.length; i++) {
      ret += arr[i].substring(0,1).toUpperCase();
      ret += arr[i].substring(1) + " ";
    }
    return ret.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10.0,
        backgroundColor: AppColors.prussianBlue,
        title: Text(toTitleCase(deckName)),
      ),
      backgroundColor: AppColors.whiteSmoke,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanStart: (_) {
          //User started dragging screen, skip timer
          if (!timer.isDismissed && !_controller.isAnimating) {
            timer.stop();
            timer.value = 0.0;
          }
        },
        onTap: () {
          //User tapped screen, skip timer
          if (!timer.isDismissed && !_controller.isAnimating) {
            timer.stop();
            timer.value = 0.0;
          }
        },
        child: Column(
          children: <Widget>[
            Expanded(
                child: Stack(
              children: <Widget>[
                backCard(),
                middleCard(),
                topCard(),

                // Prevent swiping if the cards are animating
                _controller.status != AnimationStatus.forward &&
                        timer.status == AnimationStatus.dismissed
                    ? SizedBox.expand(
                        child: GestureDetector(
                        onPanUpdate: (DragUpdateDetails details) {
                          //While dragging the first card,
                          //Add what the user swiped in the last frame to the alignment of the card
                          setState(() {
                            topCardAlign = Alignment(
                                topCardAlign.x +
                                    20 *
                                        details.delta.dx /
                                        MediaQuery.of(context).size.width,
                                topCardAlign.y +
                                    40 *
                                        details.delta.dy /
                                        MediaQuery.of(context).size.height);

                            topCardRot = topCardAlign.x;
                          });
                        },
                        onPanEnd: (_) {
                          //When releasing the first card
                          //If the front card was swiped far enough to count as swiped
                          if (topCardAlign.x > 3.0) {
                            correct = true;
                            setState(() {
                              resetAnimators();
                            });
                          } else if (topCardAlign.x < -3.0) {
                            correct = false;
                            setState(() {
                              resetAnimators();
                            });
                          } else {
                            //Otherwise go back to initial rotation and alignment
                            setState(() {
                              topCardAlign = defaultTopCardAlign;
                              topCardRot = 0.0;
                            });
                          }
                        },
                      ))
                    : Container()
              ],
            )),
            gameBar()
          ],
        ),
      ),
    );
  }

  void timerComplete() {
    _gameBarIndex = 1;
    setState(() {
      cards[0].flip();
    });
  }

  Widget backCard() {
    return Align(
      alignment: _controller.status == AnimationStatus.forward
          ? CardsAnimation.backCardAlignmentAnim(_controller).value
          : cardsAlign[0],
      child: SizedBox.fromSize(
          size: _controller.status == AnimationStatus.forward
              ? CardsAnimation.backCardSizeAnim(_controller).value
              : cardsSize[2],
          child: cards[2]),
    );
  }

  Widget middleCard() {
    return Align(
      alignment: _controller.status == AnimationStatus.forward
          ? CardsAnimation.middleCardAlignmentAnim(_controller).value
          : cardsAlign[1],
      child: SizedBox.fromSize(
          size: _controller.status == AnimationStatus.forward
              ? CardsAnimation.middleCardSizeAnim(_controller).value
              : cardsSize[1],
          child: cards[1]),
    );
  }

  Widget topCard() {
    return Align(
        alignment: _controller.status == AnimationStatus.forward
            ? CardsAnimation.topCardDisappearAlignmentAnim(
                    _controller, topCardAlign)
                .value
            : topCardAlign,
        child: Transform.rotate(
          angle: (pi / 180.0) * topCardRot,
          child: SizedBox.fromSize(size: cardsSize[0], child: cards[0]),
        ));
  }

  void refreshCards() {
    setState(() {
      cards[0] = cards[1];
      cards[0].position = 0;
      cards[1] = cards[2];
      cards[1].position = 1;
      cards[2] = WhoIsWhoCard(individual: game.next(correct), position: 2);

      counter++; //keep track of correct cards passed

      //Reset alignments
      topCardAlign = defaultTopCardAlign;
      topCardRot = 0.0;

      //Start timer again
      timer.reverse();
      _gameBarIndex = 0; //Reset gamebar to timer

      if (counter >= 20) {
        int score = game.getScore();
        Navigator.pushReplacement(
            context,
            FadeRoute(page: ScoreScreen(score, widget.deckJson)));
      }
    });
  }

  void resetAnimators() {
    _controller.stop();
    _controller.value = 0.0;
    _controller.forward();
    timer.stop();
    timer.reset();
    timer.value = 1.0;
  }

  Widget gameBar() {
    return FadeIndexedStack(
        duration: Duration(milliseconds: 300),
        index: _gameBarIndex,
        children: <Widget>[
          Container(
              height: 40.0,
              margin: EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
              child: LiquidLinearProgressIndicator(
                value: timer.value,
                valueColor: AlwaysStoppedAnimation(AppColors.coralRed),
                backgroundColor: Colors.teal,
                borderColor: AppColors.coralRed,
                borderWidth: 6.0,
                borderRadius: 12.0,
                direction: Axis.horizontal,
                center: Text(timerString,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold)),
              )),
          Container(
              height: 40.0,
              margin: EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(
                    Icons.arrow_back_ios,
                    color: Colors.red,
                    size: 40.0,
                  ),
                  Icon(
                    Icons.cancel,
                    color: Colors.red,
                    size: 40.0,
                  ),
                  Text("Swipe Card",
                      style: TextStyle(
                          color: Colors.teal,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold)),
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 40.0,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.green,
                    size: 40.0,
                  ),
                ],
              ))
        ]);
  }
}

class CardsAnimation {
  static Animation<Alignment> backCardAlignmentAnim(
      AnimationController parent) {
    return AlignmentTween(begin: cardsAlign[0], end: cardsAlign[1]).animate(
        CurvedAnimation(
            parent: parent, curve: Interval(0.4, 0.7, curve: Curves.easeIn)));
  }

  static Animation<Size> backCardSizeAnim(AnimationController parent) {
    return SizeTween(begin: cardsSize[2], end: cardsSize[1]).animate(
        CurvedAnimation(
            parent: parent, curve: Interval(0.4, 0.7, curve: Curves.easeIn)));
  }

  static Animation<Alignment> middleCardAlignmentAnim(
      AnimationController parent) {
    return AlignmentTween(begin: cardsAlign[1], end: cardsAlign[2]).animate(
        CurvedAnimation(
            parent: parent, curve: Interval(0.2, 0.5, curve: Curves.easeIn)));
  }

  static Animation<Size> middleCardSizeAnim(AnimationController parent) {
    return SizeTween(begin: cardsSize[1], end: cardsSize[0]).animate(
        CurvedAnimation(
            parent: parent, curve: Interval(0.2, 0.5, curve: Curves.easeIn)));
  }

  static Animation<Alignment> topCardDisappearAlignmentAnim(
      AnimationController parent, Alignment beginAlign) {
    return AlignmentTween(
            begin: beginAlign,
            end: Alignment(
                beginAlign.x > 0 ? beginAlign.x + 30.0 : beginAlign.x - 30.0,
                0.0) // Has swiped to the left or right?
            )
        .animate(CurvedAnimation(
            parent: parent, curve: Interval(0.0, 0.5, curve: Curves.easeIn)));
  }
}
