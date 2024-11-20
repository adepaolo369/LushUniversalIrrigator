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
                    onChanged: (bool value) {
                      setState(() {
                        activeToggle = value;
                      });
                      String targetUUID;
                      switch(valveNum){
                        case 1:
                          targetUUID = '19B10001-E8F2-537E-4F6C-D104768A1214';
                          break;
                        case 2:
                          targetUUID = '19B10001-E8F2-537E-4F6C-D104768A1215';
                          break;
                        case 3:
                          targetUUID = '19B10001-E8F2-537E-4F6C-D104768A1216';
                          break;
                        case 4:
                          targetUUID = '19B10001-E8F2-537E-4F6C-D104768A1217';
                          break;
                        case 5:
                          targetUUID = '19B10001-E8F2-537E-4F6C-D104768A1218';
                          break;
                        case 6:
                          targetUUID = '19B10001-E8F2-537E-4F6C-D104768A1219';
                          break;
                        case 7:
                          targetUUID = '19B10001-E8F2-537E-4F6C-D104768A1220';
                          break;
                        default:
                          targetUUID = 'defaultUUID';
                          break;
                      }

                      if(value){
                        print("Writing value: '1' to $targetUUID");
                        writeBoolCharacteristic('1', targetUUID);
                      }
                      else{
                        print("Writing value: '0' to $targetUUID");
                        writeBoolCharacteristic('0', targetUUID);
                      }
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
                      String targetUUID;
                      switch(valveNum){
                        case 1:
                          targetUUID = '19B10001-E8F2-537E-4F6C-D104768A1259';
                          break;
                        case 2:
                          targetUUID = '19B10001-E8F2-537E-4F6C-D104768A1260';
                          break;
                        case 3:
                          targetUUID = '19B10001-E8F2-537E-4F6C-D104768A1261';
                          break;
                        case 4:
                          targetUUID = '19B10001-E8F2-537E-4F6C-D104768A1262';
                          break;
                        case 5:
                          targetUUID = '19B10001-E8F2-537E-4F6C-D104768A1263';
                          break;
                        case 6:
                          targetUUID = '19B10001-E8F2-537E-4F6C-D104768A1264';
                          break;
                        case 7:
                          targetUUID = '19B10001-E8F2-537E-4F6C-D104768A1265';
                          break;
                        default:
                          targetUUID = 'defaultUUID';
                          break;
                      }
                      print("Writing value: '1' to $targetUUID");
                      writeBoolCharacteristic('1', targetUUID);
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
                      keyboardType: TextInputType.numberWithOptions(decimal: false),
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
                      keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                      decoration: InputDecoration(
                        labelText: "Milliliters",
                        labelStyle: TextStyle(fontSize: 18, color: Colors.black),
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      onSubmitted: (value) {
                        if(value.isNotEmpty){
                          String targetUUID;
                          switch(valveNum){
                            case 1:
                              targetUUID = '19B10001-E8F2-537E-4F6C-D104768A1228';
                              break;
                            case 2:
                              targetUUID = '19B10001-E8F2-537E-4F6C-D104768A1229';
                              break;
                            case 3:
                              targetUUID = '19B10001-E8F2-537E-4F6C-D104768A1230';
                              break;
                            case 4:
                              targetUUID = '19B10001-E8F2-537E-4F6C-D104768A1231';
                              break;
                            case 5:
                              targetUUID = '19B10001-E8F2-537E-4F6C-D104768A1232';
                              break;
                            case 6:
                              targetUUID = '19B10001-E8F2-537E-4F6C-D104768A1233';
                              break;
                            case 7:
                              targetUUID = '19B10001-E8F2-537E-4F6C-D104768A1234';
                              break;
                            default:
                              targetUUID = 'defaultUUID';
                              break;
                          }
                          writeIntCharacteristic(value, targetUUID);
                        }
                      },
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
                      String targetUUID;
                      switch(valveNum){
                        case 1:
                          targetUUID = '19B10001-E8F2-537E-4F6C-D104768A1252';
                          break;
                        case 2:
                          targetUUID = '19B10001-E8F2-537E-4F6C-D104768A1253';
                          break;
                        case 3:
                          targetUUID = '19B10001-E8F2-537E-4F6C-D104768A1254';
                          break;
                        case 4:
                          targetUUID = '19B10001-E8F2-537E-4F6C-D104768A1255';
                          break;
                        case 5:
                          targetUUID = '19B10001-E8F2-537E-4F6C-D104768A1256';
                          break;
                        case 6:
                          targetUUID = '19B10001-E8F2-537E-4F6C-D104768A1257';
                          break;
                        case 7:
                          targetUUID = '19B10001-E8F2-537E-4F6C-D104768A1258';
                          break;
                        default:
                          targetUUID = 'defaultUUID';
                          break;
                      }
                      print("Writing value: '1' to $targetUUID");
                      writeBoolCharacteristic('1', targetUUID);
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
                        keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                        decoration: InputDecoration(
                          labelText: "Milliliters",
                          labelStyle: TextStyle(fontSize: 18, color: Colors.black),
                          border: OutlineInputBorder(),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            String targetUUID;
                            switch (valveNum) {
                              case 1:
                                targetUUID =
                                '19B10001-E8F2-537E-4F6C-D104768A1266';
                                break;
                              case 2:
                                targetUUID =
                                '19B10001-E8F2-537E-4F6C-D104768A1267';
                                break;
                              case 3:
                                targetUUID =
                                '19B10001-E8F2-537E-4F6C-D104768A1268';
                                break;
                              case 4:
                                targetUUID =
                                '19B10001-E8F2-537E-4F6C-D104768A1269';
                                break;
                              case 5:
                                targetUUID =
                                '19B10001-E8F2-537E-4F6C-D104768A1270';
                                break;
                              case 6:
                                targetUUID =
                                '19B10001-E8F2-537E-4F6C-D104768A1271';
                                break;
                              case 7:
                                targetUUID =
                                '19B10001-E8F2-537E-4F6C-D104768A1272';
                                break;
                              default:
                                targetUUID = 'defaultUUID';
                                break;
                            }
                            print("Writing value: $value to $targetUUID");
                            writeIntCharacteristic(value, targetUUID);
                          }
                        }
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
