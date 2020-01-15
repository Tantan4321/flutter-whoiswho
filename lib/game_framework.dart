import 'dart:convert';
import 'dart:core';
import 'dart:ui';

class Game {
  List<Individual> remaining;
  int score;
  String setType;

  Game(
    var jsonData,
  ) {
    setType = "bruh";
    remaining = jsonToList(jsonData); //TODO: implement lazy loaded data
    score = 0;
  }

  List<Individual> jsonToList(jsonData) {
    var l = json.decode(jsonData);
    setType = l[0];
    return l[setType]
        .map<Individual>((jsonObject) => Individual.fromJson(jsonObject))
        .toList();
  }
}

class Individual {
  String name;
  String imagePath;

  Individual(this.name, this.imagePath);

  factory Individual.fromJson(Map<String, dynamic> jsonObject) {
    return Individual(jsonObject["name"], jsonObject["img"]);
  }

  String getName(){
    return name;
  }

  String getPath(){
    return imagePath;
  }

}
