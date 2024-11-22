import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import '/common/styles.dart';
import 'package:flutter/services.dart';
import 'package:lui_project/luiHomeScreen.dart';
import 'package:lui_project/common/systemVars.dart';
import 'package:lui_project/common/bluetoothFunction.dart';
import 'package:lui_project/common/Global.dart';
import 'package:lui_project/allValvesPage.dart';
List<Valve> valveList = [];
final TextEditingController timeController = TextEditingController();
final TextEditingController waterAmountController = TextEditingController();
final TextEditingController hourController = TextEditingController();
final TextEditingController minuteController = TextEditingController();

class ValveSettings extends StatefulWidget {
  @override
  ValveSettingsState createState() => ValveSettingsState();
}

class ValveSettingsState extends State<ValveSettings> {
  @override
  void initState() {
    super.initState();
    BluetoothDevice device = BluetoothDevice.fromId(SystemInfoHandler().getDeviceID() ?? "none");
    if(device.isDisconnected)
    {
      BleController().connectToDevice(device, context);
    }
    valveLoad();
    updateTime();

  }
  bool amPM = false;
  String globalHour = '0';
  String globalMinute = '0';

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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: currentHeight * 0.1,
        title: Text('Your Valves', style: LuiTextTheme.luiH1),
        backgroundColor: Colors.cyan[300],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.cyan[200],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Water Time",
                  style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 16),
                Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: TextField(
                        controller: hourController,
                        keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                        decoration: InputDecoration(
                          labelText: "H",
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
                            if(int.parse(value) > 12){
                              int hourMax = 12;
                              value = hourMax.toString();
                            }
                            if(int.parse(value) < 0){
                              int hourMax = 1;
                              value = hourMax.toString();
                            }
                            setState(() {
                              hourController.text = value;
                            });
                            if(int.parse(value) == 12 && amPM == false){
                              int zeroHour = 0;
                              value = zeroHour.toString();
                            }
                            if(int.parse(value) != 12 && amPM == true){
                              int zeroHour = int.parse(value) + 12;
                              value = zeroHour.toString();
                            }
                            globalHour =value;
                            BleController().writeIntCharacteristic(globalHour, '19b10001-e8f2-537e-4f6c-d104768a1250');
                            BleController().writeIntCharacteristic(globalMinute, '19b10001-e8f2-537e-4f6c-d104768a1251');
                          }
                        },
                      ),
                    ),
                    Text(
                      " : ",
                      style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Flexible(
                      child: TextField(
                        controller: minuteController,
                        keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                        decoration: InputDecoration(
                          labelText: "M",
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
                            if(int.parse(value) > 59){
                              int mixMax = 59;
                              value = mixMax.toString();
                            }
                            if(int.parse(value) < 0){
                              int minMax = 0;
                              value = minMax.toString();
                            }
                            setState(() {
                              minuteController.text = value;
                            });
                            globalMinute = value;
                            BleController().writeIntCharacteristic(globalHour, '19b10001-e8f2-537e-4f6c-d104768a1250');
                            BleController().writeIntCharacteristic(globalMinute, '19b10001-e8f2-537e-4f6c-d104768a1251');
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      "AM",
                      style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Switch(
                    value: amPM,
                      onChanged: (bool value) {
                        setState(() {
                          amPM = value;
                        });
                        if(value){
                          globalHour = (int.parse(globalHour) + 12).toString();
                        }
                        else{
                          globalHour = (int.parse(globalHour) - 12).toString();
                        }
                        BleController().writeIntCharacteristic(globalHour, '19b10001-e8f2-537e-4f6c-d104768a1250');
                        BleController().writeIntCharacteristic(globalMinute, '19b10001-e8f2-537e-4f6c-d104768a1251');
                      },
                    ),
                    Text(
                      "PM",
                      style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                ),
              ],
            ),
          ),
        SizedBox(height: 16),
        // Expanded ListView to display valve items
        Expanded(
          child: ListView.builder(
            itemCount: valveList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => ValveInput()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.cyan[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      "Valve: ${valveList[index].valveID}, Water Amount: ${valveList[index].waterAmount}",
                      style: TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 10), // Space between ListView and button
        // Add button styled like a list item
        GestureDetector(
          onTap: () {
            // Use the current instance to show the dialog
            showAddValveDialog(context);
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.green[300],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Icon(
                Icons.add,
                size: 28.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    ),
    );
  }


  void showAddValveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add New Valve"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: waterAmountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Water Amount"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without saving
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                int waterAmount = int.tryParse(waterAmountController.text) ?? 0;

                // Add the new valve item to the list
                setState(() {
                  Valve currentValve = Valve(
                    valveID: valveList.length + 1, // Incremental ID
                    waterAmount: waterAmount, inUse: true);
                  valveList.add(currentValve);
                  SystemInfoHandler().addValve(currentValve);
                });

                Navigator.of(context).pop(); // Close dialog

                // Clear input fields
                timeController.clear();
                waterAmountController.clear();
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }
}

void valveLoad()
{
  valveList =  SystemInfoHandler().getValves();
  if(valveList.isEmpty)
    {
      valveList=[];
    }
  return;
}
void updateTime() {
  final now = DateTime.now();
  BleController().writeIntCharacteristic(now.second.toString(), '19b10001-e8f2-537e-4f6c-d104768a1247');
  BleController().writeIntCharacteristic(now.minute.toString(), '19b10001-e8f2-537e-4f6c-d104768a1246');
  BleController().writeIntCharacteristic(now.hour.toString(), '19b10001-e8f2-537e-4f6c-d104768a1245');
  BleController().writeIntCharacteristic(now.day.toString(), '19b10001-e8f2-537e-4f6c-d104768a1242');
  BleController().writeIntCharacteristic(now.month.toString(), '19b10001-e8f2-537e-4f6c-d104768a1243');
  BleController().writeIntCharacteristic(now.year.toString(), '19b10001-e8f2-537e-4f6c-d104768a1244');
  BleController().writeIntCharacteristic(now.weekday.toString(), '19b10001-e8f2-537e-4f6c-d104768a1248');
  return;
}
