import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import '/common/styles.dart';
import 'package:flutter/services.dart';
import 'package:lui_project/luiHomeScreen.dart';
import 'package:lui_project/common/systemVars.dart';

List<Valve> valveList = SystemInfoHandler().getValves() as List<Valve>;

class ValveSettings extends StatefulWidget
{
  @override
  ValveSettingsState createState() => ValveSettingsState();
}

class ValveSettingsState extends State<ValveSettings>
{
  @override

   Widget build(BuildContext context)
  {
    return Column();
  }
}

Widget valveDisplay(BuildContext context)
{
    return ListView.builder(itemCount: valveList.length,
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          //onTap: () => ,
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              "Time: ${valveList[index].time}, Water Amount: ${valveList[index].waterAmount}",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      );
    },
    );
}

