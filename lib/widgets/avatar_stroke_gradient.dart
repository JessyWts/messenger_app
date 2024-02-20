import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';

import 'avatar.dart';

class AvatarStrokeGradient extends StatelessWidget {
  final EdgeInsets margin ;
  final List<Color> colors;
  final AvatarWidget avatar;

  const AvatarStrokeGradient({
    super.key, required this.margin, required this.colors, required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        border: GradientBoxBorder(
          gradient: LinearGradient(
            colors: colors
          ),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(50)
      ),
      child: avatar,
    );
  }
}