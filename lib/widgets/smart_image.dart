import 'package:flutter/material.dart';
import 'dart:io';

class SmartImage extends StatelessWidget {
  final String file;
  static final String urlPattern =
      r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
  final match = RegExp(urlPattern, caseSensitive: false);
  ImageProvider image;

  SmartImage(this.file) {
    var firstmatch = match.firstMatch(this.file);
    if (firstmatch != null) {
      image = NetworkImage(file);
    } else if (file.startsWith("assets")) {
      image = AssetImage(file);
    }else{
      image = AssetImage("assets/img/error_image.jpg");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Image(
      image: image,
      fit: BoxFit.cover,
    );
  }
}
