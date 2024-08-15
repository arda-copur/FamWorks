
import 'package:flutter/material.dart';

@immutable
final class AppBorders extends BorderRadius {


   /// [AppBorders.circularLow] is 8
   AppBorders.circularLow() : super.circular(8);
   /// [AppBorders.circularSmall] is 10
   AppBorders.circularSmall() : super.circular(10);
   /// [AppBorders.circularNormal] is 20
   AppBorders.circularNormal() : super.circular(20);
   /// [AppBorders.circularLarge] is 30
   AppBorders.circularLarge() : super.circular(30);
   /// [AppBorders.circularCustom] is 24
   AppBorders.circularCustom() : super.circular(24);
  
}