import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:lui_project/ValvesPage.dart';
import 'package:lui_project/common/systemVars.dart';
import '/common/styles.dart';
import 'package:flutter/services.dart';
import 'package:lui_project/luiInitialSetup.dart';
import 'package:lui_project/ValveSettingsPage.dart';
class luiSplashScreen extends StatefulWidget {
  const luiSplashScreen({super.key});

  @override
  State<luiSplashScreen> createState() => _luiSplashScreenState();
}

class _luiSplashScreenState extends State<luiSplashScreen> with SingleTickerProviderStateMixin
{
  bool setupComplete = SystemInfoHandler().deviceSetupComplete();

  @override

  void initState()
  {
    //SystemInfoHandler().setSetUpStatus(false);
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(Duration(seconds: 2),()
    {
      if(setupComplete)
        {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => ValvePage(),));
        }
      else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => InitialSetup(),));
      }
    });
  }

  void dispose()
  {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    overlays: SystemUiOverlay.values);
    super.dispose();

  }

  Widget build(BuildContext context) {
    double currentheight = MediaQuery.of(context).size.height;
    double currentwidth = MediaQuery.of(context).size.width;

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
       children: [
         Transform.rotate(
           angle: 0.5,
         child: Icon(
         WeatherIcons.wi_raindrop,
         size: currentwidth * 0.6,
         color: Colors.lightBlue,
         )),
         Text('Lush Universal Irrigator',
           style: LuiTextTheme.luiH1,
         )
         ]
     )
   ),
    );
  }
}

