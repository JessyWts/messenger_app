import 'package:flutter/material.dart';
import 'package:messenger_app/constant.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const Responsive({
    Key? key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  }) : super(key: key);

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < defaultMobileWidth;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= defaultMobileWidth &&
      MediaQuery.of(context).size.width <= defaultDesktopWidth;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width > defaultDesktopWidth;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (size.width > defaultDesktopWidth) {
      return desktop;
    } else if (size.width >= defaultMobileWidth && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}
