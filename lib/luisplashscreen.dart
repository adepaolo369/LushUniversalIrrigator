import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import '/common/styles.dart';
class luiSplashScreen extends StatefulWidget {
  const luiSplashScreen({super.key});

  @override
  State<luiSplashScreen> createState() => _luiSplashScreenState();
}

class _luiSplashScreenState extends State<luiSplashScreen> {
  @override

  Widget build(BuildContext context) {
    double currentheight;
    double currentwidth;


    return Scaffold(
   body: Container(
     width: double.infinity,
     height: double.infinity,
     alignment: Alignment.center,
     decoration: BoxDecoration(
       gradient: LinearGradient(
         colors:[Colors.lightGreenAccent,Colors.green],
         begin: Alignment.topRight,
         end: Alignment.bottomLeft,
       ),
     ),
     child: Wrap(
         crossAxisAlignment: WrapCrossAlignment.center,
         direction: Axis.vertical,
        verticalDirection: VerticalDirection.down,
       alignment: WrapAlignment.center,
       children: const [
         Icon(
         WeatherIcons.wi_raindrop,
         size: 250,
         color: Colors.lightBlue,
         ),
         Text('Lush Universal Irrigator',
           style: LuiTextTheme.luiHeader,
         )
         ]
     )
   ),
    );
  }
}

