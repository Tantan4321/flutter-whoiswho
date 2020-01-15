import 'dart:convert';
import 'dart:core';
import 'dart:ui';

class Game {
  List<Individual> remaining;
  int score;
  String setType;

  Game(var jsonData, ) {
    setType = "person";
    remaining = jsonToList(jsonData); //TODO: implement lazy loaded data
    score = 0;
  }

  List<Individual> jsonToList(jsonData, ){
    var ret = new List();
    for (var item in jsonData){
      ret.add(Individual(item['name'], item['img']));
    }

    return ret;
  }
}

class Individual {
  String name;
  String img;

  Individual(this.name, this.img);

}