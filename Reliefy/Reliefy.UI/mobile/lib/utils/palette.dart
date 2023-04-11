import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor kMainTheme = MaterialColor(
    0xff6388C3, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xff6388C3), //10%
      100: Color(0xff7193C8), //20%
      200: Color(0xff7E9DCD), //30%
      300: Color(0xff8AA6D2), //40%
      400: Color(0xff95AED6), //50%
      500: Color(0xff9FB5DA), //60%
      600: Color(0xffA8BCDD), //70%
      700: Color(0xffB0C2E0), //80%
      800: Color(0xffB7C8E3), //90%
      900: Color(0xffBECDE6), //100%
    },
  );
}