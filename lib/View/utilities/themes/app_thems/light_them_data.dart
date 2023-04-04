import 'package:flutter/material.dart';
import '../app_colors/light_colors.dart';
import '../fonts.dart';

ThemeData lightThemeData() => ThemeData(
      brightness: Brightness.light,
      primaryColor: LightColors.primary,
      scaffoldBackgroundColor: LightColors.background,
      // backgroundColor: LightColors.background,
      fontFamily: Fonts.mainFontFamily,
      // accentColor: LightColors.accent,
      dividerColor: LightColors.divider,
      //drawerTheme: DrawerThemeData(backgroundColor: LightColors.drawer,scrimColor: LightColors.drawer),
      elevatedButtonTheme:
          ElevatedButtonThemeData(style: ElevatedButton.styleFrom()),
      appBarTheme: const AppBarTheme(
          elevation: 0.0,
          color: LightColors.background,
          centerTitle: true,
          toolbarTextStyle: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
          iconTheme: IconThemeData(color: LightColors.primary)),
    );
