import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';


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
               print("Found device: ${result.device.name} - ${result.device.id}");
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
  Future<void> connectToDevice(BluetoothDevice device)async
  {
    await device.connect(timeout: Duration(seconds: 15));
    device.connectionState.listen((isConnected)
    {
       if(isConnected == BluetoothConnectionState.connected)
       {
        print("Device connected: ${device.advName}");
      }
       else
       {
        print("Device Disconnected");
      }
    });
  }
    Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;
}