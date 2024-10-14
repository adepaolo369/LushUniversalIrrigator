import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

class luiSplashScreen extends StatefulWidget {
  const luiSplashScreen({super.key});

  @override
  State<luiSplashScreen> createState() => _luiSplashScreenState();
}

class _luiSplashScreenState extends State<luiSplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
   body: Container(
     decoration: BoxDecoration(
       gradient: LinearGradient(
         colors:[Colors.lightGreenAccent,Colors.green],
         begin: Alignment.topRight,
         end: Alignment.bottomLeft,
       ),
     ),
   ),
    );
  }
}

