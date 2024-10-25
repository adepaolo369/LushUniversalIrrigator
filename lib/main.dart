import 'package:flutter/material.dart';
import 'package:lui_project/luisplashscreen.dart';
import 'package:lui_project/common/systemVars.dart';
import 'luiHomeScreen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemInfoHandler.init(); // Initialize preferences
  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: luiSplashScreen(),
    );
  }
}
