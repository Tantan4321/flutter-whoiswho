import 'package:flutter/material.dart';
import 'dart:io';

class SmartImage extends StatelessWidget {
  final String file;
  static final String urlPattern =
      r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
  final match = RegExp(urlPattern, caseSensitive: false);
  FadeInImage image;

  SmartImage(this.file) {
    var firstmatch = match.firstMatch(this.file);
    if (firstmatch != null) {
      image = FadeInImage.assetNetwork(
          fit: BoxFit.cover,
          fadeInDuration: Duration(milliseconds: 100),
          placeholder: "assets/img/error_image.jpg",
          image: file);
    } else if (file.startsWith("assets")) {
      image = FadeInImage.assetNetwork(
          fit: BoxFit.cover,
          fadeInDuration: Duration(milliseconds: 100),
          placeholder: "assets/img/error_image.jpg",
          image: file);
    }else{
      image = FadeInImage.assetNetwork(
          fit: BoxFit.cover,
          image: "assets/img/error_image.jpg");
    }
  }

  @override
  Widget build(BuildContext context) {
    return image;
  }
}
