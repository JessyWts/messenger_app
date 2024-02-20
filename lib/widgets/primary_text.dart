import 'package:flutter/material.dart';
import 'package:messenger_app/constant.dart';

class PrimaryText extends StatelessWidget {
   final String text;
   final Color color;
   final double fontSize;
   final FontWeight fontWeight;
   final TextOverflow overflow;
   final String fontFamily;

  const PrimaryText({super.key, 
    required this.text,
    this.color = Colors.black,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w700,
    this.overflow = TextOverflow.visible,
    this.fontFamily =  defaultFontFamily,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
      ),
    );
  }
}
