import 'dart:convert';
import 'dart:core';

class Game {
  List<Individual> remaining;
  List<Individual> displayed;
  int score;
  String setType;

  Game(var jsonData) {
    setType = "bruh";
    remaining = jsonToList(jsonData); //TODO: implement lazy loaded data
    score = 0;
  }

  List<Individual> jsonToList(jsonData) {
    var l = json.decode(jsonData);
    return l
        .map<Individual>((jsonObject) => Individual.fromJson(jsonObject))
        .toList();
  }

  int getScore() {
    return score;
  }

  Individual next(bool lastCorrect) {
    var last = displayed.removeLast();
    if (!lastCorrect) {
      remaining.insert(0, last);
    }

    var next = remaining.removeLast();
    while (displayed.contains(next)) {
      //If already displayed, get another card
      remaining.insert(0, next);
      next = remaining.removeLast();
    }
    displayed.insert(0, next);
    return next;
  }

  List<Individual> getFirstFew(int num) {
    var temp = List.generate(num, (index) => remaining.removeLast());
    var tempReversed = temp.reversed;
    displayed = tempReversed.toList();
    return temp;
  }
}

class Individual {
  String name;
  String imagePath;

  Individual(this.name, this.imagePath);

  factory Individual.fromJson(Map<String, dynamic> jsonObject) {
    return Individual(jsonObject["name"], jsonObject["img"]);
  }

  String getName() {
    return name;
  }

  String getPath() {
    return imagePath;
  }
}
