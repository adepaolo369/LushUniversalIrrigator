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
final TextEditingController timeController = TextEditingController();
final TextEditingController waterAmountController = TextEditingController();

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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Expanded ListView to display valve items
        Expanded(
          child: ListView.builder(
            itemCount: globalLocalList.length,
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
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      "Valve: ${globalLocalList[index].valveID}, Water Amount: ${globalLocalList[index].waterAmountAutomatic}",
                      style: TextStyle(fontSize: 18, color: Colors.white),
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
              color: Colors.blueAccent,
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
                    valveID: globalLocalList.length + 1, // Incremental ID
                    waterAmountAutomatic: waterAmount, waterAmountManual: 0, actualWaterAmount: 0, inUse: true);
                  globalLocalList.add(currentValve);
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
  globalLocalList =  SystemInfoHandler().getValves();
  if(globalLocalList.isEmpty)
    {
      globalLocalList=[];
    }
  return;
}
