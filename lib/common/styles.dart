import 'package:flutter/material.dart';

abstract class LuiTextTheme
{
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

  static final TextStyle luiH2 = TextStyle(
    fontFamily: 'Poppins',
      color: Colors.black,
      fontSize: 30,
      fontStyle: FontStyle.italic,
      height: 0.1,
      fontWeight: FontWeight.w600);

  static final TextStyle luiT1 = TextStyle(
      fontFamily: 'Poppins',
      color: Colors.black,
      fontSize: 20,
      fontStyle: FontStyle.italic,
      height: 0.1,
      fontWeight: FontWeight.w600
  );

}