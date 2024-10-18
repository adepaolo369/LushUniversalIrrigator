import 'package:flutter/material.dart';
import 'package:lui_project/common/styles.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();

}

class HomeScreenState extends State<HomeScreen>
{


  Widget build(BuildContext context)
  {
    double currentheight = MediaQuery.of(context).size.height;
    double currentwidth = MediaQuery.of(context).size.width;
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
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
            [Text('Welcome to LUI!'),
              const SizedBox(height: 20), // Adds spacing between widgets
              const Text('Enjoy smart irrigation!'),]
      ),

      )

    );
  }
}

