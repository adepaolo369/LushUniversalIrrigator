import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:lui_project/ValvesPage.dart';
import 'package:lui_project/common/systemVars.dart';
import '/common/styles.dart';
import 'package:flutter/services.dart';
import 'package:lui_project/luiInitialSetup.dart';
import 'package:lui_project/ValveSettingsPage.dart';

//Class for splash screen page, create initial state and derive a key for page.
class luiSplashScreen extends StatefulWidget
{
  const luiSplashScreen({super.key});

  @override
  State<luiSplashScreen> createState() => _luiSplashScreenState();
}

//Create a class for splash screen state.
class _luiSplashScreenState extends State<luiSplashScreen> with SingleTickerProviderStateMixin
{
  bool setupComplete = SystemInfoHandler().deviceSetupComplete();

  @override
  //Initialization state
  void initState()
  {

    //Inherited initState
    super.initState();

    //Set UI to immersive to get rid of bottom and top toolbar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    /*Two second function that checks if setup is complete
    * and thus where to route the user to
    * (either the setup or the main valves page.) */
    Future.delayed(Duration(seconds: 2),()
    {
      if(setupComplete)
        {
          //Use navigator function to navigate to Valve page with current context.)
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => ValvePage(),));
        }
      else
      {
        //Navigate to InitialSetup page with current context
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => InitialSetup(),));
      }
    });
  }

  //Dispose function for when widget is disposed of.
  void dispose()
  {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    overlays: SystemUiOverlay.values);
    super.dispose();

  }


//Main build widget
  Widget build(BuildContext context)
  {


    //Return a screen with green gradient background and a centered logo with title.
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
        //Wrap for alignment and size.
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          direction: Axis.vertical,
          verticalDirection: VerticalDirection.down,
          alignment: WrapAlignment.center,
          children:
          [//Show sized logo and title of project
            ClipRRect(
              borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
              child: Image.asset(
                'assets/LUILogo.png',
                width: 200, // Adjust the width as needed
                height: 200, // Adjust the height as needed
                fit: BoxFit.cover, // Ensures the image fits the rounded container
              ),
            ),
            SizedBox(height:30),
            Text('Lush Universal Irrigator',
              style: LuiTextTheme.luiH1,
            )
          ]
        )
      ),
    );
  }


}

