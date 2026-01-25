import 'package:course_scheduling/core/theme/app_pallet.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static  _border([Color color = AppPallete.borderColor])  =>OutlineInputBorder(
    borderSide:  BorderSide(color: color, width: 3),
    borderRadius:BorderRadius.circular(10),
  );
  static final darkThemeMode = ThemeData.dark().copyWith(
    // primaryColor:Colors.red
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppPallete.backgroundColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.all(27),
      // filled: true,
      enabledBorder: _border(),
      focusedBorder: _border(AppPallete.gradient2),

    ),

  );
}
