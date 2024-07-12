

import 'package:flutter/material.dart';

mixin TaskViewStylesMixin {
  TextStyle? get taskTitleStyle => Theme.of(context).textTheme.bodyMedium;
  TextStyle? get taskSubtitleStyle => Theme.of(context).textTheme.bodyLarge;
  TextStyle? get taskDescriptionStyle => Theme.of(context).textTheme.bodySmall;
  TextStyle? get taskButtonStyle => Theme.of(context).textTheme.displayLarge;

  BuildContext get context;
}