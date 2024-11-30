import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lui_project/ValvesPage.dart';
import 'package:lui_project/luisplashscreen.dart';
import 'package:lui_project/common/systemVars.dart';
import 'luiInitialSetup.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:lui_project/ValveSettingsPage.dart';


//Main function for running app
void main() async
{
  //Ensure initialization of handling of the widget tree
  WidgetsFlutterBinding.ensureInitialized();
  //Wait for the sharedPreferences memory handler to initialize
  await SystemInfoHandler.init(); // Initialize preferences
  //Run the application
  runApp( MyApp());
}

//Declaration of our app class.
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  //Create new state of MyApp, uses the initState function to initialize this.
  @override
  State<MyApp> createState() => MyAppState();


}
//Main App state class
class MyAppState extends State<MyApp>
{
  //Initialization of bluetooth adapterState to utilize bluetooth capabilities
  BluetoothAdapterState adapterState = BluetoothAdapterState.unknown;
  //Declare new data stream subscription for gleaming data from adapter.
  late StreamSubscription<BluetoothAdapterState> adapterStateStateSubscription;

//Override super's initState function to create our own
  @override
  void initState()
  {
    //Inherit parts of the initState
    super.initState();
    //Set bluetooth adapter to begin listening
    adapterStateStateSubscription = FlutterBluePlus.adapterState.listen((state){
      //Set adapter state
      adapterState = state;
      //If widget state is mounted, set state of adapter.
      if(mounted){
        setState((){});
      }

    });
  }

  //Override disposal function to create our own
  @override
  void dispose()
  {
    adapterStateStateSubscription.cancel();
    super.dispose();
  }

  //Start of widget tree, main build widget holding the entirety of the app
  Widget build(BuildContext context)
  {
    return MaterialApp(
      //Disable the debug banner for presentation purposes
      debugShowCheckedModeBanner: false,
      //Set home page to splash screen
      home: luiSplashScreen(),
    );
  }
}
