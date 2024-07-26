import 'package:flutter/material.dart';

class AppHeightBox extends StatelessWidget {
  final double? height;
  final double? width;
  

  const AppHeightBox({
    Key? key,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 8.0,
      width: width,
    );
  }
}

class AppWidthBox extends StatelessWidget {
  final double? height;
  final double? width;
  

  const AppWidthBox({
    Key? key,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width ?? 8.0,
    );
  }
}