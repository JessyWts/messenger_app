import 'package:flutter/material.dart';

class CircleElevatedButton extends StatelessWidget {
  final double height;
  final double width;
  final double elevation;
  final Color backgroundColor;
  final double padding;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onPressed;

  const CircleElevatedButton({
    super.key, 
    required this.height, 
    required this.width,
    this.elevation = 0,
    this.backgroundColor = Colors.white54, 
    required this.padding, 
    required this.icon, 
    this.iconColor = Colors.white, 
    required this.onPressed,  
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(backgroundColor),
          elevation: MaterialStatePropertyAll(elevation),
          padding: MaterialStatePropertyAll(EdgeInsets.all(padding)),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          )
        ),
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
    );
  }
}