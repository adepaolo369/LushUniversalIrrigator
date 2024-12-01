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
    //Listen for the bluetooth connection state of device after an attempt at connecting.
    device.connectionState.listen((isConnected)
    {
      //If the connection is successful, show alert dialog to let user know of success.
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
         //Save device ID for re-connection later.
         SystemInfoHandler().saveDeviceID(device.remoteId.toString());
      }
       else
       {//Test code
        print("Device Disconnected");
      }
    });
    //Wait for discovering of device services.
    await discover(device);
  }
    //A special get method to create a data stream gotten from the scan results.
    Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;

  //Future method to get all services from the specific device and store them in a global variable.
  Future<void> discover(BluetoothDevice device) async
  {
    //Get services and store in global variable.
    servicesGlobal = await device.discoverServices();
  }
  //Future void method to write a integer to a specified UUID characteristic.
  //This is used for writing int data to the board's specific services.
  Future<void> writeIntCharacteristic(String value, String uuid) async
  {

    try {
      //Parse string value as an int.
      int intValue = int.parse(value);
      //Print int value to console for logging purposes
      print("int intValue: $intValue");
      //Create a list of byte values based on int and do bit shifting to store them.
      List<int> byteValue = [
        (intValue & 0xFF),
        (intValue >> 8 & 0xFF),
      ];
      //Print int byte value to console
      print("int bytleValue: $byteValue");

      //Variable to track whether a characteristic has been written to
      bool characteristicWritten = false;

      //For all services in the global services variable...
      for (BluetoothService service in servicesGlobal)
      {
        //For all the characteristics in the service...
        for (BluetoothCharacteristic characteristic in service.characteristics)
        {
          //If the specific characteristic equals the parameter uuID...
          if (characteristic.uuid.toString() == uuid)
          {
            // Check if the characteristic is writable..
            if (characteristic.properties.write)
            {
              //If true, then print to console UUID and write the byte value to the characteristic.
              print("Writing to characteristic with UUID: $uuid");
              await characteristic.write(byteValue);
              characteristicWritten = true;
              break;
            }
            //Else, print to console the UUID is not writable.
            else
            {
              print("Characteristic with UUID $uuid is not writable.");
            }
          }
        }
        //If already written, then break loop.
        if (characteristicWritten) break;
      }

      //If unable to write to, then print not writable to console.
      if (!characteristicWritten)
      {
        print("No writable characteristic found with UUID: $uuid");
      }
    } catch (e) {
      print("Error writing characteristic: $e");
    }
  }

  //Future method to write a boolean variable to the Arduino board.
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