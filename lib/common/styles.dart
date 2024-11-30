import 'package:flutter/material.dart';

//Abstract class for holding lui text styles.
abstract class LuiTextTheme
{
  //Header 1 Style
  static final TextStyle luiH1 = TextStyle(
    fontFamily: 'Poppins',
    color: Colors.white,
    shadows: [
    Shadow(
    blurRadius: 10.0,
    color: Colors.black.withOpacity(0.5), // Shadow color
    offset: Offset(5.0, 5.0), // Shadow position
  ),],
    fontSize: 39,
    fontStyle: FontStyle.italic,
    height: 0.1,
    fontWeight: FontWeight.bold);

  //Header 2 style
  static final TextStyle luiH2 = TextStyle(
    fontFamily: 'Poppins',
      color: Colors.black,
      fontSize: 30,
      fontStyle: FontStyle.italic,
      height: 0.1,
      fontWeight: FontWeight.w600);

  //Body Text 1 style
  static final TextStyle luiT1 = TextStyle(
      fontFamily: 'Poppins',
      color: Colors.black,
      fontSize: 20,
      fontStyle: FontStyle.italic,
      height: 0.1,
      fontWeight: FontWeight.w600
  );

}