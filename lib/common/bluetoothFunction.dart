import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:lui_project/common/systemVars.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:lui_project/common/Global.dart';
import 'dart:convert';



class BleController extends GetxController
{

  Future<void> requestPermissions() async {
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.locationWhenInUse.request();
  }

  void setFlutterBlueLogLevel() {
    FlutterBluePlus.setLogLevel(LogLevel.verbose, color: false);
    return;
  }
// This Function will help users to scan near by BLE devices and get the list of Bluetooth devices.
  Future scanDevices() async
  {
     //turnOnBluetooth();
    setFlutterBlueLogLevel();
    await requestPermissions();
    if (await Permission.bluetoothScan
        .request()
        .isGranted) {
      if (await Permission.bluetoothConnect
          .request()
          .isGranted) {
         FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
         FlutterBluePlus.scanResults.listen((results) {
           if (results.isEmpty) {
             print("No devices found");
           } else {
             for (ScanResult result in results) {
               print("Found device: ${result.device.advName} - ${result.device.remoteId}");
             }
           }
         });
        FlutterBluePlus.stopScan();
         int i = await FlutterBluePlus.scanResults.length ;
         print("Hello how are you omg please work  $i");
      }
    }
  }
// This function will help user to connect to BLE devices.
  Future<void> connectToDevice(BluetoothDevice device, BuildContext context)async
  {
    try {
      await device.connect(timeout: Duration(seconds: 15));
    }
    catch(e)
    {
      showDialog(
        context: context,
        builder: (BuildContext context)
        {
          return AlertDialog(
            title: Text("ERROR - Device Failed to Connect"),
            content: Text("Device ${device.advName} failed to connect - Error 001"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          );
        },
      );

      return;
    }
    device.connectionState.listen((isConnected)
    {
       if(isConnected == BluetoothConnectionState.connected)
       {
         showDialog(
           context: context,
           builder: (BuildContext context)
           {
             return AlertDialog(
               title: Text("Connected"),
               content: Text("Device connected: ${device.advName}"),
               actions: [
                 TextButton(
                   onPressed: () => Navigator.pop(context),
                   child: Text("OK"),
                 ),
               ],
             );
           },
         );
         SystemInfoHandler().saveDeviceID(device.remoteId.toString());
      }
       else
       {
        print("Device Disconnected");
      }
    });
    await discover(device);
  }
    Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;
}

Future<void> discover(BluetoothDevice device) async {
  servicesGlobal = await device.discoverServices();
}

/*Future<void> writeIntCharacteristic(String value, String uuid) async {
  try{
    int intValue = int.parse(value);
    List<int> byteValue = [
      (intValue & 0xFF), // Lower byte (least significant)
      (intValue >> 8 & 0xFF), // Upper byte (most significant)
    ];

    for (BluetoothService service in servicesGlobal) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.uuid.toString() == uuid) {
          //write to characteristic
          await characteristic.write(byteValue);
          return;
        }
      }
    }
  } catch (e) {
    print(e);
  }
} */

Future<void> writeIntCharacteristic(String value, String uuid) async {
  try {
    int intValue = int.parse(value);
    print("int intValue: $intValue");
    List<int> byteValue = [
      (intValue & 0xFF), // Lower byte (least significant)
      (intValue >> 8 & 0xFF), // Upper byte (most significant)
    ];

    print("int bytleValue: $byteValue");

    bool characteristicWritten = false;

    for (BluetoothService service in servicesGlobal) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.uuid.toString() == uuid) {
          // Check if the characteristic is writable
          if (characteristic.properties.write) {
            print("Writing to characteristic with UUID: $uuid");
            await characteristic.write(byteValue);
            characteristicWritten = true;
            break;
          } else {
            print("Characteristic with UUID $uuid is not writable.");
          }
        }
      }
      if (characteristicWritten) break;  // Stop searching once we find the characteristic
    }

    if (!characteristicWritten) {
      print("No writable characteristic found with UUID: $uuid");
    }
  } catch (e) {
    print("Error writing characteristic: $e");
  }
}

/*Future<void> writeBoolCharacteristic(String value, String uuid) async {
  try{
    int intValue = int.parse(value);
    List<int> byteValue = [(intValue & 0xFF)];

    for (BluetoothService service in servicesGlobal) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.uuid.toString() == uuid) {
          //write to characteristic
          print("Writing to characteristic UUID: ${characteristic.uuid}");
          await characteristic.write(byteValue);
          return;
        }
      }
    }
  } catch (e) {
    print(e);
  }
}*/

Future<void> writeBoolCharacteristic(String value, String uuid) async {
  try {
    int intValue = int.parse(value);
    print("bool intValue: $intValue");
    List<int> byteValue = [(intValue & 0xFF)];

    print("bytleValue: $byteValue");

    bool characteristicWritten = false;

    for (BluetoothService service in servicesGlobal) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.uuid.toString() == uuid) {
          // Check if the characteristic is writable
          if (characteristic.properties.write) {
            print("Writing to characteristic with UUID: $uuid");
            await characteristic.write(byteValue);
            characteristicWritten = true;
            break;
          } else {
            print("Characteristic with UUID $uuid is not writable.");
          }
        }
      }
      if (characteristicWritten) break;  // Stop searching once we find the characteristic
    }

    if (!characteristicWritten) {
      print("No writable characteristic found with UUID: $uuid");
    }
  } catch (e) {
    print("Error writing characteristic: $e");
  }
}


