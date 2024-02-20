import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final double height;
  final double width;
  final EdgeInsetsGeometry? margin;
  final bool isShadow;
  final String imagePath;
  final String? userName;

  const AvatarWidget({
    super.key, this.height = 60, this.width = 60,  required this.imagePath, this.isShadow = false, this.userName, this.margin, 
  });

  @override
  Widget build(BuildContext context) {
    var randomColor = Random().nextInt(18);

    return Container(
      margin: margin,
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        boxShadow: isShadow ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0.1,
            blurRadius: 3
          )
        ] : null,
        image: imagePath.isNotEmpty ? DecorationImage(
          //image: AssetImage(imagePath),
          image: CachedNetworkImageProvider(imagePath,),
          fit: BoxFit.cover
        ) : null,
        color: (imagePath.isEmpty && userName!.isNotEmpty) ? Colors.primaries[randomColor] : null,
      ),
      padding: (imagePath.isEmpty && userName!.isNotEmpty) ? const EdgeInsets.symmetric(vertical: 13) : null,
      child: (imagePath.isEmpty && userName!.isNotEmpty) ? textInCircle(userName!) : null,
    );
  }
}

Widget textInCircle (String userName) {
  return Text(
    userName.toUpperCase()[0],
    textAlign: TextAlign.center,
    style: const TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.w400,
    ),
  );
}