import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lui_project/ValveSettings.dart';
import 'package:lui_project/luisplashscreen.dart';
import 'package:lui_project/common/systemVars.dart';
import 'luiHomeScreen.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:lui_project/allValvesPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemInfoHandler.init(); // Initialize preferences
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => MyAppState();


}

class MyAppState extends State<MyApp>
{
  BluetoothAdapterState adapterState = BluetoothAdapterState.unknown;

  late StreamSubscription<BluetoothAdapterState> adapterStateStateSubscription;
  // This widget is the root of your application.
  @override
  void initState()
  {
    super.initState();
    adapterStateStateSubscription = FlutterBluePlus.adapterState.listen((state){
      adapterState = state;
      if(mounted){
        setState((){});
      }

    });
  }

  @override
  void dispose(){
    adapterStateStateSubscription.cancel();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: luiSplashScreen(),
    );
  }
}
