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
    await device.connect(timeout: Duration(seconds: 15));
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
         SystemInfoHandler.saveDeviceID(device.remoteId.toString());
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

Future<void> writeIntCharacteristic(String value, String uuid) async {
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
}

Future<void> writeBoolCharacteristic(String value, String uuid) async {
  try{
    int intValue = int.parse(value);
    List<int> byteValue = [(intValue & 0xFF)];

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
}


