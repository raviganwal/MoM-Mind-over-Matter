import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AppText {
  static Widget normalText(
    String text, {
    double fontSize = 18,
    Color color = const Color(0xff333333),
    bool isBold = false,
    TextAlign textAlign = TextAlign.center,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontFamily: 'Source Sans Pro',
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      ),
      textAlign: textAlign,
    );
  }
}
