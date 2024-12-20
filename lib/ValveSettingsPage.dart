import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import '/common/styles.dart';
import 'package:flutter/services.dart';
import 'package:lui_project/luiInitialSetup.dart';
import 'package:lui_project/common/systemVars.dart';
import 'package:lui_project/common/bluetoothFunction.dart';
import 'package:lui_project/common/Global.dart';
import 'package:lui_project/ValvesPage.dart';

final TextEditingController volumeTrackController = TextEditingController();
final TextEditingController waterPerDayController = TextEditingController();
final TextEditingController manualCycleController = TextEditingController();

class ValveSettings extends StatefulWidget {
  const ValveSettings({super.key});

  @override
  ValveSettingsState createState() => ValveSettingsState();
}

class ValveSettingsState extends State<ValveSettings> {

  @override
  void initState() {
    super.initState();
    valveLoad();
    subscribeToVolTrackingCharacteristic();
    if(globalLocalList.isNotEmpty) {
      volumeTrackController.text = globalLocalList[globalIndex].actualWaterAmount.toString();
      waterPerDayController.text = globalLocalList[globalIndex].waterAmountAutomatic.toString();
      manualCycleController.text = globalLocalList[globalIndex].waterAmountManual.toString();
    }
  }


  bool activeToggle = globalLocalList[globalIndex].inUse;
  bool modeToggle = globalLocalList[globalIndex].mode;
  int valveNum = globalLocalList[globalIndex].valveID;
  bool refilled = false;
  bool manualWater = false;
  String lastReceivedValue = "";

  @override
  Widget build(BuildContext context) {
    double currentHeight = MediaQuery
        .of(context)
        .size
        .height;
    double currentWidth = MediaQuery
        .of(context)
        .size
        .width;
    Widget valveTitle;
    switch(valveNum){
      case 1:
        valveTitle = Text("Valve 1", style: LuiTextTheme.luiH1);
        break;
      case 2:
        valveTitle = Text("Valve 2", style: LuiTextTheme.luiH1);
        break;
      case 3:
        valveTitle = Text("Valve 3", style: LuiTextTheme.luiH1);
        break;
      case 4:
        valveTitle = Text("Valve 4", style: LuiTextTheme.luiH1);
        break;
      case 5:
        valveTitle = Text("Valve 5", style: LuiTextTheme.luiH1);
        break;
      case 6:
        valveTitle = Text("Valve 6", style: LuiTextTheme.luiH1);
        break;
      case 7:
        valveTitle = Text("Valve 7", style: LuiTextTheme.luiH1);
        break;
      default:
        valveTitle = Text("Default Valve", style: LuiTextTheme.luiH1);
        break;
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: currentHeight *0.1,
        actions:[overallBluth],
        title: valveTitle,
        backgroundColor: Colors.cyan[300],

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
                color: Colors.cyan[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Valve Enable",
                    style: TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold),
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
                          targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1214';
                          break;
                        case 2:
                          targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1215';
                          break;
                        case 3:
                          targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1216';
                          break;
                        case 4:
                          targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1217';
                          break;
                        case 5:
                          targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1218';
                          break;
                        case 6:
                          targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1219';
                          break;
                        case 7:
                          targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1220';
                          break;
                        default:
                          targetUUID = 'defaultUUID';
                          break;
                      }

                      if(value){
                        print("Writing value: '1' to $targetUUID");
                        globalLocalList[globalIndex].inUse = true;
                        SystemInfoHandler().saveValves(globalLocalList);
                        BleController().writeBoolCharacteristic('1', targetUUID);
                      }
                      else{
                        print("Writing value: '0' to $targetUUID");
                        globalLocalList[globalIndex].inUse = false;
                        SystemInfoHandler().saveValves(globalLocalList);
                        BleController().writeBoolCharacteristic('0', targetUUID);
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
                color: Colors.cyan[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Valve Mode",
                    style: TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 180,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Daily",
                          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Switch(
                          value: modeToggle,
                          onChanged: (bool value) {
                            setState(() {
                              modeToggle = value;
                            });
                            String targetUUID;
                            switch(valveNum){
                              case 1:
                                targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1221';
                                break;
                              case 2:
                                targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1222';
                                break;
                              case 3:
                                targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1223';
                                break;
                              case 4:
                                targetUUID = '19b10001-e8f2-537e-4f6c-d104768a124';
                                break;
                              case 5:
                                targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1225';
                                break;
                              case 6:
                                targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1226';
                                break;
                              case 7:
                                targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1227';
                                break;
                              default:
                                targetUUID = 'defaultUUID';
                                break;
                            }

                            if(value){
                              print("Writing value: '1' to $targetUUID");
                              globalLocalList[globalIndex].mode = true;
                              SystemInfoHandler().saveValves(globalLocalList);
                              BleController().writeBoolCharacteristic('1', targetUUID);
                            }
                            else{
                              print("Writing value: '0' to $targetUUID");
                              globalLocalList[globalIndex].mode = false;
                              SystemInfoHandler().saveValves(globalLocalList);
                              BleController().writeBoolCharacteristic('0', targetUUID);
                            }
                          },
                        ), //
                        Text(
                          "Weekly",
                          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.cyan[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Press when refilled.",
                    style: TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String targetUUID;
                      switch(valveNum){
                        case 1:
                          targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1259';
                          break;
                        case 2:
                          targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1260';
                          break;
                        case 3:
                          targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1261';
                          break;
                        case 4:
                          targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1262';
                          break;
                        case 5:
                          targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1263';
                          break;
                        case 6:
                          targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1264';
                          break;
                        case 7:
                          targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1265';
                          break;
                        default:
                          targetUUID = 'defaultUUID';
                          break;
                      }
                      print("Writing value: '1' to $targetUUID");
                      BleController().writeBoolCharacteristic('1', targetUUID);
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[300],
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                        "Refilled",
                        style: TextStyle(fontSize: 18, color: Colors.white,fontWeight: FontWeight.bold)
                    ),
                  ), //
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.cyan[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Milliliters Remaining",
                    style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(
                    width: 125,
                    child: TextField(
                      controller: volumeTrackController,
                      readOnly: true,
                      keyboardType: TextInputType.numberWithOptions(decimal: false,signed: false),
                      decoration: InputDecoration(
                        labelText: "Milliliters",
                        labelStyle: TextStyle(fontSize: 18, color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      textAlign: TextAlign.center,
                    ), //
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.cyan[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Auto Milliliters",
                    style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 125,
                    child: TextField(
                      controller: waterPerDayController,
                      keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                      decoration: InputDecoration(
                        labelText: "Milliliters",
                        labelStyle: TextStyle(fontSize: 18, color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      textAlign: TextAlign.center,
                      onSubmitted: (value) {
                        if(value.isNotEmpty){
                          String targetUUID;
                          switch(valveNum){
                            case 1:
                              targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1228';
                              break;
                            case 2:
                              targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1229';
                              break;
                            case 3:
                              targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1230';
                              break;
                            case 4:
                              targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1231';
                              break;
                            case 5:
                              targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1232';
                              break;
                            case 6:
                              targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1233';
                              break;
                            case 7:
                              targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1234';
                              break;
                            default:
                              targetUUID = 'defaultUUID';
                              break;
                          }
                          globalLocalList[globalIndex].waterAmountAutomatic = int.parse(value);
                          SystemInfoHandler().saveValves(globalLocalList);
                          BleController().writeIntCharacteristic(value, targetUUID);
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
                color: Colors.cyan[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Manual Cycle Start",
                    style: TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String targetUUID;
                      switch(valveNum){
                        case 1:
                          targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1252';
                          break;
                        case 2:
                          targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1253';
                          break;
                        case 3:
                          targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1254';
                          break;
                        case 4:
                          targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1255';
                          break;
                        case 5:
                          targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1256';
                          break;
                        case 6:
                          targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1257';
                          break;
                        case 7:
                          targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1258';
                          break;
                        default:
                          targetUUID = 'defaultUUID';
                          break;
                      }
                      print("Writing value: '1' to $targetUUID");
                      BleController().writeBoolCharacteristic('1', targetUUID);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[300],
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                        "Water",
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)
                    ),
                  ), //
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.cyan[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Manual Milliliters",
                    style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 125,
                    child: TextField(
                        controller: manualCycleController,
                        keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                        decoration: InputDecoration(
                          labelText: "Milliliters",
                          labelStyle: TextStyle(fontSize: 18, color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          fillColor: Colors.white,
                          filled: true,

                        ),
                        textAlign: TextAlign.center,
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            String targetUUID;
                            switch (valveNum) {
                              case 1:
                                targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1266';
                                break;
                              case 2:
                                targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1267';
                                break;
                              case 3:
                                targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1268';
                                break;
                              case 4:
                                targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1269';
                                break;
                              case 5:
                                targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1270';
                                break;
                              case 6:
                                targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1271';
                                break;
                              case 7:
                                targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1272';
                                break;
                              default:
                                targetUUID = 'defaultUUID';
                                break;
                            }
                            print("Writing value: $value to $targetUUID");
                            globalLocalList[globalIndex].waterAmountManual = int.parse(value);
                            SystemInfoHandler().saveValves(globalLocalList);
                            BleController().writeIntCharacteristic(value, targetUUID);
                          }
                        }
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.cyan[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Delete Valve",
                    style: TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if(globalLocalList.length == 1)
                      {
                        SystemInfoHandler().clearValves();
                        Navigator.pop(context);
                        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => ValvePage()));
                      }
                      else {
                        SystemInfoHandler().deleteValve(valveNum);
                        Navigator.pop(context);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (
                            context) => ValvePage()));
                      }
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[300],
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                        "Delete",
                        style: TextStyle(fontSize: 18, color: Colors.white,fontWeight: FontWeight.bold)
                    ),
                  ), //
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void subscribeToVolTrackingCharacteristic() {
    String targetUUID;
    switch (valveNum) {
      case 1:
        targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1235';
        break;
      case 2:
        targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1236';
        break;
      case 3:
        targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1237';
        break;
      case 4:
        targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1238';
        break;
      case 5:
        targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1239';
        break;
      case 6:
        targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1240';
        break;
      case 7:
        targetUUID = '19b10001-e8f2-537e-4f6c-d104768a1241';
        break;
      default:
        targetUUID = 'defaultUUID';
        break;
    }
    BleController().subscribeToCharacteristic(targetUUID, updateCharacteristicValue);
  }
  void updateCharacteristicValue(String newValue) {
    if (newValue != lastReceivedValue) { // Only update if value has changed
      setState(() {
        lastReceivedValue = newValue;
        print("Updating remaining milliliters newValue: $newValue");
        globalLocalList[globalIndex].actualWaterAmount = int.parse(newValue);
        SystemInfoHandler().saveValves(globalLocalList);
        volumeTrackController.text = newValue; // Update the TextField
      });
    }
  }
}