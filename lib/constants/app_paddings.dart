import 'package:flutter/material.dart';

final class AppPaddings extends EdgeInsets {
  // All Paddings

  /// [AppPaddings.allSmall] is 8
  const AppPaddings.allSmall() : super.all(8);

  /// [AppPaddings.allNormal] is 10
  const AppPaddings.allNormal() : super.all(10);

  /// [AppPaddings.allMedium] is 16
  const AppPaddings.allMedium() : super.all(16);

  /// [AppPaddings.allLarge] is 24
  const AppPaddings.allLarge() : super.all(24);

  /// [AppPaddings.allHigh] is 32
  const AppPaddings.allHigh() : super.all(32);

  // Symmetric Paddings

  /// [AppPaddings.symmetricSmall] is horizontal 10 vertical 10
  const AppPaddings.symmetricSmall()
      : super.symmetric(horizontal: 10, vertical: 10);

  /// [AppPaddings.symmetricMedium] is horizontal 20 vertical 20
  const AppPaddings.symmetricMedium()
      : super.symmetric(horizontal: 20, vertical: 20);

  //Only Paddings

  /// [AppPaddings.onlyLeft] is left 10
   const AppPaddings.onlyLeft() : super.only(left: 10);

    /// [AppPaddings.onlyRight] is right 10
  const AppPaddings.onlyRight() : super.only(right: 10);

  /// [AppPaddings.onlyTop] is top 10
  const AppPaddings.onlyTop() : super.only(top: 10);

    /// [AppPaddings.onlyBottom] is bottom 10
  const AppPaddings.onlyBottom() : super.only(bottom: 10);

  /// [AppPaddings.onlyLeftRight] is left 10 right 10
  const AppPaddings.onlyLeftRight() : super.only(left: 10, right: 10);

  
}