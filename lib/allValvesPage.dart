import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import '/common/styles.dart';
import 'package:flutter/services.dart';
import 'package:lui_project/luiHomeScreen.dart';
import 'package:lui_project/common/systemVars.dart';
import 'package:lui_project/common/bluetoothFunction.dart';
import 'package:lui_project/common/Global.dart';
import 'package:lui_project/ValveSettings.dart';

final TextEditingController volumeTrackController = TextEditingController();
final TextEditingController waterPerDayController = TextEditingController();
final TextEditingController manualCycleController = TextEditingController();

class ValveInput extends StatefulWidget {
  @override
  ValveInputState createState() => ValveInputState();
}

class ValveInputState extends State<ValveInput> {
  @override
  void initState() {
    super.initState();
    valveLoad();
  }

  bool activeToggle = true;
  bool refilled = false;
  bool manualWater = false;
  int valveNum = 1;

  @override
  Widget build(BuildContext context) {
    Widget valveTitle;
    switch(valveNum){
      case 1:
        valveTitle = Text("Valve 1");
        break;
      case 2:
        valveTitle = Text("Valve 2");
        break;
      case 3:
        valveTitle = Text("Valve 3");
        break;
      case 4:
        valveTitle = Text("Valve 4");
        break;
      case 5:
        valveTitle = Text("Valve 5");
        break;
      case 6:
        valveTitle = Text("Valve 6");
        break;
      case 7:
        valveTitle = Text("Valve 7");
        break;
      default:
        valveTitle = Text("Default Valve");
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: valveTitle,
        titleTextStyle: TextStyle(fontSize: 24, color: Colors.white),
        backgroundColor: Colors.blue,

      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Valve in use.",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Switch(
                    value: activeToggle,
                    onChanged: (value) {
                      setState(() {
                        activeToggle = value;
                      });
                    },
                  ), //
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Press when refilled.",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          refilled = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                          "Refilled",
                          style: TextStyle(fontSize: 18, color: Colors.white)
                      ),
                    ), //
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Milliliters Remaining",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    SizedBox(width: 16),
                    SizedBox(
                      width: 125,
                      child: TextField(
                        controller: volumeTrackController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                        ],
                        decoration: InputDecoration(
                          labelText: "Milliliters",
                          labelStyle: TextStyle(fontSize: 18, color: Colors.black),
                          border: OutlineInputBorder(),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ), //
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Milliliters Per Day",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    SizedBox(width: 16),
                    SizedBox(
                      width: 125,
                      child: TextField(
                        controller: waterPerDayController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                        ],
                        decoration: InputDecoration(
                          labelText: "Milliliters",
                          labelStyle: TextStyle(fontSize: 18, color: Colors.black),
                          border: OutlineInputBorder(),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Manual Cycle Start",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          manualWater = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                          "Water",
                          style: TextStyle(fontSize: 18, color: Colors.white)
                     ),
                    ), //
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Manual Cycle Milliliters",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    SizedBox(width: 16),
                    SizedBox(
                      width: 125,
                      child: TextField(
                        controller: manualCycleController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                        ],
                        decoration: InputDecoration(
                            labelText: "Milliliters",
                            labelStyle: TextStyle(fontSize: 18, color: Colors.black),
                            border: OutlineInputBorder(),
                            fillColor: Colors.white,
                            filled: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
