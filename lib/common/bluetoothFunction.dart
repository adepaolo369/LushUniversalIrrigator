import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';


class BleController extends GetxController
{

// This Function will help users to scan near by BLE devices and get the list of Bluetooth devices.
  Future scanDevices() async
  {
    if (await Permission.bluetoothScan
        .request()
        .isGranted) {
      if (await Permission.bluetoothConnect
          .request()
          .isGranted) {
        FlutterBluePlus.startScan(timeout: Duration(seconds: 15));
        FlutterBluePlus.stopScan();
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
