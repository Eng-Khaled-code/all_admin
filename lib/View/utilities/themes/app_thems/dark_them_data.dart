import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_colors/dark_colors.dart';
import '../fonts.dart';

ThemeData darkThemeData() => ThemeData(
      primaryColor: DarkColors.primary,
      brightness: Brightness.dark,
      dividerColor: DarkColors.divider,
      accentColor: DarkColors.primary,
      fontFamily: Fonts.mainFontFamily,
      cupertinoOverrideTheme:
          const CupertinoThemeData(brightness: Brightness.dark),
      scaffoldBackgroundColor: DarkColors.background,
      elevatedButtonTheme:
          ElevatedButtonThemeData(style: ElevatedButton.styleFrom()),
    );
