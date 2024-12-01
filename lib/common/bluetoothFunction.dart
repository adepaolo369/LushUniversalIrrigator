import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:lui_project/common/systemVars.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:lui_project/common/Global.dart';
import 'package:lui_project/ValveSettingsPage.dart';

//Bluetooth manager class declaration
class BleController extends GetxController
{

  //Future method to request the appropriate user permissions for needed bluetooth capabilities.
  Future<void> requestPermissions() async
  {
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.locationWhenInUse.request();
  }

  //Log level for debug testing
  void setFlutterBlueLogLevel()
  {
    FlutterBluePlus.setLogLevel(LogLevel.verbose, color: false);
    return;
  }

//Future function that connects to desired bluetooth device.
  Future<void> connectToDevice(BluetoothDevice device, BuildContext context)async
  {
    //Try catch block for device connection
    try
    {
      await device.connect(timeout: Duration(seconds: 15));
    }
    catch(e)
    {
      //If failure to connect, return error alert dialogue to user.
      showDialog(
        context: context,
        builder: (BuildContext context)
        {
          return AlertDialog(
            title: Text("ERROR - Device Failed to Connect"),
            content: Text("Valve Control failed to connect - Error 001"),
            actions:
            [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],//Actions grouping
          );
        },//Builder
      );//ShowDialog

      return;//Return and exit method without doing anything.
    }
    //Listen for the connection state after an attempt at connecting.
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
               content: Text("Valve Control has been connected."),
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
  Future<void> discover(BluetoothDevice device) async {
    servicesGlobal = await device.discoverServices();
  }

  Future<void> writeIntCharacteristic(String value, String uuid) async {
    try {
      int intValue = int.parse(value);
      print("int intValue: $intValue");
      List<int> byteValue = [
        (intValue & 0xFF),
        (intValue >> 8 & 0xFF),
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
        if (characteristicWritten) break;
      }

      if (!characteristicWritten) {
        print("No writable characteristic found with UUID: $uuid");
      }
    } catch (e) {
      print("Error writing characteristic: $e");
    }
  }

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
        if (characteristicWritten) break;
      }

      if (!characteristicWritten) {
        print("No writable characteristic found with UUID: $uuid");
      }
    } catch (e) {
      print("Error writing characteristic: $e");
    }
  }

  Future<void> subscribeToCharacteristic(String uuid, Function(String) onValueChanged) async {
    try {
      bool characteristicSubscribed = false;

      for (BluetoothService service in servicesGlobal) {
        for (BluetoothCharacteristic characteristic in service.characteristics) {
          if (characteristic.uuid.toString() == uuid) {
            // Check if the characteristic is notifiable
            if (characteristic.properties.notify) {
              print("Writing to characteristic with UUID: $uuid");
              await characteristic.setNotifyValue(true);
              characteristic.lastValueStream.listen((value) {
                print("Updating remaining milliliters value: $value");
                int  intValue = (value[0]) |
                (value[1] << 8) |
                (value[2] << 16) |
                (value[3] << 24);
                String newValue = intValue.toString();
                onValueChanged(newValue);
              });
              characteristicSubscribed = true;
              break;
            } else {
              print("Characteristic with UUID $uuid is not notifiable.");
            }
          }
        }
        if (characteristicSubscribed) break;
      }

      if (!characteristicSubscribed) {
        print("No notifiable characteristic found with UUID: $uuid");
      }
    } catch (e) {
      print("Error subscribing to characteristic: $e");
    }
  }
}





class BluetoothStatusIndicator extends StatelessWidget
{
  Stream<List<BluetoothDevice>> getConnectedDevicesStream()
  {
    return Stream.periodic(const Duration(seconds: 2))
        .asyncMap((_) => FlutterBluePlus.connectedDevices);
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BluetoothDevice>>(
      stream: getConnectedDevicesStream(),
      builder: (context, snapshot) {
        final connectedDevices = snapshot.data ?? [];
        final isConnected = connectedDevices.isNotEmpty;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Icon(
                isConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
                color: isConnected ? Colors.blue : Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                isConnected ? 'Connected' : 'Disconnected',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
      },
    );
  }
}