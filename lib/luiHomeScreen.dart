import 'package:flutter/material.dart';
import 'package:lui_project/common/styles.dart';
import 'package:lui_project/common/systemVars.dart';
class HomeScreen extends StatefulWidget
{
  @override
  HomeScreenState createState() => HomeScreenState();

}

class HomeScreenState extends State<HomeScreen>
{
bool setupComplete = false;//SystemInfoHandler().isSetupComplete();
bool deviceSetupLoad = true;


@override
  Widget build(BuildContext context)
  {
    double currentHeight = MediaQuery.of(context).size.height;
    double currentWidth = MediaQuery.of(context).size.width;
    return Scaffold
      (
      appBar: AppBar(
        title: Text('Lush Universal Irrigater', style: LuiTextTheme.luiH1),
        backgroundColor: Colors.cyan[300]
        ,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: (setupComplete)? valveSetupLoading(context) : initialSetup(context),

      )

    );
  }

  Widget initialSetup(BuildContext context)
  {
    double currentHeight = MediaQuery.of(context).size.height;
    double currentWidth = MediaQuery.of(context).size.width;
    return Container(
  width: double.infinity,
  height: double.infinity,
  child: Column(
  mainAxisAlignment: MainAxisAlignment.start,
  children:
  [SizedBox(height: currentHeight * 0.30),
  Text('Welcome to LUI!', style: LuiTextTheme.luiH1,),
  SizedBox(height: currentHeight * 0.05), // Adds spacing between widgets
  Text('Click the button below to begin setup', style: LuiTextTheme.luiT1,),
  SizedBox(height: currentHeight * 0.03),
  ElevatedButton(onPressed:(){ setState(()
  { setupComplete = true; deviceSetupLoad = true; deviceSetup();  });}, child: Text('Press Me', style: LuiTextTheme.luiT1)),]
  ),);
  }

Future<void> deviceSetup() async
{
  //device setup stuff goes here,
  await Future.delayed(Duration(seconds: 1));
  SystemInfoHandler().setSetUpStatus(setupComplete);
  setState(() {
    deviceSetupLoad = false;
  });
}

  Widget valveSetupLoading(BuildContext context)
  {
      return Center(
        child: deviceSetupLoad ? CircularProgressIndicator() : AvailableDevices(context),
      );
  }

  Widget AvailableDevices(BuildContext context)
  {
  return Container();
  }
  }

