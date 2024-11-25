import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import '/common/styles.dart';
import 'package:flutter/services.dart';
import 'package:lui_project/luiInitialSetup.dart';
import 'package:lui_project/common/systemVars.dart';
import 'package:lui_project/common/bluetoothFunction.dart';
import 'package:lui_project/common/Global.dart';
import 'package:lui_project/ValveSettingsPage.dart';

import 'ValvesPage.dart';

class SettingsPage extends StatefulWidget {

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {

  void initState() {
    super.initState();
  }

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
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('Settings', style: LuiTextTheme.luiH1),]
        ),
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
                  "Restart Setup",
                  style: TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BluetoothScanScreen()));
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[300],
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                      "Restart",
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
                  "Information",
                  style: TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: ()
                  {
                    showDialog(
                      context: context,
                      builder: (BuildContext context)
                      {
                        return AlertDialog(
                          title: Text("Information"),
                          content: Text("Developers: Andrew Nash and Alexander N. DePalo"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[300],
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                      "Press",
                      style: TextStyle(fontSize: 18, color: Colors.white,fontWeight: FontWeight.bold)
                  ),
                ), //
              ],
            ),
          ),
        ]
    )
    ),
    );
  }
}


class BluetoothScanScreen extends StatefulWidget
{
  @override
  BluetoothScanScreenState createState() => BluetoothScanScreenState();

}

class BluetoothScanScreenState extends State<BluetoothScanScreen> {

  List<BluetoothDevice> systemDevices = [];
  List<ScanResult> scanResults = [];
  bool isScanning = false;
  late StreamSubscription<List<ScanResult>> scanResultsSubscription;
  late StreamSubscription<bool> isScanningSubscription;
  BluetoothAdapterState adapterState = BluetoothAdapterState.unknown;
  late StreamSubscription<BluetoothAdapterState> adapterStateStateSubscription;

  @override
  void initState() {
    super.initState();
    BluetoothDevice device = BluetoothDevice.fromId(SystemInfoHandler().getDeviceID() ?? "none");
    if(device.isConnected)
      {
        device.disconnect();
      }

    adapterStateStateSubscription = FlutterBluePlus.adapterState.listen((state){
      adapterState = state;
      if(mounted){
        setState((){});
      }

    });

    scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      scanResults = results;
      if (mounted) {
        setState(() {});
      }
    }, onError: (e) {
      print("wow it broke oof");
    });

    isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      isScanning = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  /*void dispose() {
    scanResultsSubscription.cancel();
    isScanningSubscription.cancel();
    setupComplete = false;
    SystemInfoHandler().setSetUpStatus(setupComplete);
    super.dispose();
  }*/
  Future onScanPressed() async {
    try {
      // `withServices` is required on iOS for privacy purposes, ignored on android.
      var withServices = [Guid("180f")]; // Battery Level Service
      systemDevices = await FlutterBluePlus.systemDevices(withServices);
    } catch (e) {
      print(e);
    }
    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15), withNames: ["Valve Control"]);
    } catch (e) {
      print(e);
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future onStopPressed() async {
    try {
      FlutterBluePlus.stopScan();
    } catch (e) {
      print(e);
    }
  }

  Future onRefresh() {
    if (isScanning == false) {
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    }
    if (mounted) {
      setState(() {});
    }
    return Future.delayed(Duration(milliseconds: 500));
  }


  @override
  Widget build(BuildContext context)
  {
    double currentHeight = MediaQuery
        .of(context)
        .size
        .height;
    double currentWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold
      (
        appBar: AppBar(
          toolbarHeight: currentHeight *0.1,
          title: Text('Setup', style: LuiTextTheme.luiH1),
          backgroundColor: Colors.cyan[300]
          ,
        ),
        body: Container(
          width: currentWidth,
          height: currentHeight,
          child: availableDevices(context)
        )
    );
  }


  Widget availableDevices(BuildContext context) {
    double currentHeight = MediaQuery
        .of(context)
        .size
        .height;
    double currentWidth = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
        appBar: AppBar(title: Text("LUI Device Setup"),),
        body: GetBuilder<BleController>(
          init: BleController(),
          builder: (BleController controller)
          {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder<List<ScanResult>>(
                      stream: controller.scanResults,
                      builder: (context, snapshot) {
                        if (snapshot.data?.isNotEmpty ?? false)
                        {
                          return Flexible(
                            fit: FlexFit.tight,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  final data = snapshot.data![index];
                                  return Card(
                                    elevation: 2,
                                    child: ListTile(
                                        title: Text(data.device.advName),
                                        subtitle: Text(data.device.remoteId.toString()),
                                        trailing: Text(data.rssi.toString()),
                                        onTap: ()=> {
                                          SystemInfoHandler().saveDeviceID(data.device.remoteId.toString()),
                                          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => ValvePage())),
                                        }

                                    ),
                                  );
                                }),
                          );
                        }else{
                          return Center(child: Text("No Device Found"),);
                        }
                      }),
                  SizedBox(height: 10,),
                  ElevatedButton(onPressed: ()
                  {
                    onScanPressed();
                    // await controller.disconnectDevice();
                  }, child: Text("SCAN")),
                ],
              ),
            );
          },
        )
    );
  }


}