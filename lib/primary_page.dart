import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_whoiswho/card.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'game_framework.dart';
import 'dart:math';

List<Alignment> cardsAlign = [
  Alignment(0.0, 1.0),
  Alignment(0.0, 0.8),
  Alignment(0.0, 0.0)
];
List<Size> cardsSize = List(3);

class HomeScreen extends StatefulWidget {
  HomeScreen(BuildContext context) {
    cardsSize[0] = Size(MediaQuery.of(context).size.width * 0.9,
        MediaQuery.of(context).size.height * 0.6);
    cardsSize[1] = Size(MediaQuery.of(context).size.width * 0.85,
        MediaQuery.of(context).size.height * 0.55);
    cardsSize[2] = Size(MediaQuery.of(context).size.width * 0.8,
        MediaQuery.of(context).size.height * 0.5);
  }

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Game game;

  List<WhoIsCard> cards = List();
  AnimationController _controller;

  final Alignment defaultTopCardAlign = Alignment(0.0, 0.0);
  Alignment topCardAlign;
  double topCardRot = 0.0;

  @override
  void initState() {
    super.initState();
    //Init the game
    game = Game();
    //Get the first few cards
    List<Individual> firstFew = game.getFirstFew(cardsSize.length);

    //Init cards
    for (int i = 0; i < firstFew.length; i++) {
      cards.add(WhoIsCard(individual: firstFew[i], position: i));
    } //Make the top card visible

    topCardAlign = cardsAlign[2];

    //Init the animation controller
    _controller =
        AnimationController(duration: Duration(milliseconds: 700), vsync: this);
    _controller.addListener(() => setState(() {}));
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) refreshCards();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
            child: Stack(
          children: <Widget>[
            backCard(),
            middleCard(),
            topCard(),

            // Prevent swiping if the cards are animating
            _controller.status != AnimationStatus.forward
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
                      if (topCardAlign.x > 3.0 || topCardAlign.x < -3.0) {
                        setState(() {
                          animateCards();
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
    );
  }

  void flipCard() {
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
      print("refreshing cards...");
      var temp = cards[0];
      cards[0] = cards[1];
      cards[0].position = 0;
      cards[1] = cards[2];
      cards[1].position = 1;
      cards[2] = WhoIsCard(individual: game.next(false), position: 2);

      //Reset alignments
      topCardAlign = defaultTopCardAlign;
      topCardRot = 0.0;
    });
  }

  void animateCards() {
    _controller.stop();
    _controller.value = 0.0;
    _controller.forward();
  }

  Widget gameBar() {
    return Container(
        height: 40.0,
        margin: EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
        child: LiquidLinearProgressIndicator(
          value: 0.2,
          valueColor: AlwaysStoppedAnimation(Colors.pink),
          borderColor: Colors.redAccent,
          borderWidth: 5.0,
          borderRadius: 12.0,
          direction: Axis.horizontal,
          center: Text("yes",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        ));
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
