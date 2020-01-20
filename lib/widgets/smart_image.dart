import 'package:flutter/material.dart';
import 'dart:io';

class SmartImage extends StatelessWidget {
  final String file;
  static final String urlPattern =
      r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
  final match = RegExp(urlPattern, caseSensitive: false);

  SmartImage(this.file);

  @override
  Widget build(BuildContext context) {
    var firstmatch = match.firstMatch(this.file);
    if (firstmatch != null) {
      return FadeInImage.assetNetwork(
          fit: BoxFit.cover,
          fadeInDuration: Duration(milliseconds: 100),
          placeholder: "assets/img/error_image.jpg",
          image: file);
    } else if (file.startsWith("assets")){
      return Image.asset(file, fit: BoxFit.cover);
    }else{
      return FadeInImage.assetNetwork(
          fit: BoxFit.cover,
          image: "assets/img/error_image.jpg");
    }

  }
}
