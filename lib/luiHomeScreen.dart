import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lui_project/common/styles.dart';
import 'package:lui_project/common/systemVars.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:lui_project/common/bluetoothFunction.dart';
import 'package:get/get.dart';

import 'ValveSettings.dart';

class HomeScreen extends StatefulWidget
{
  @override
  HomeScreenState createState() => HomeScreenState();

}

class HomeScreenState extends State<HomeScreen> {
  bool setupComplete = false;
  bool setupBegin = false;
  bool deviceSetupLoad = true;

  List<BluetoothDevice> systemDevices = [];
  List<ScanResult> scanResults = [];
  bool isScanning = false;
  late StreamSubscription<List<ScanResult>> scanResultsSubscription;
  late StreamSubscription<bool> isScanningSubscription;
  @override
  void initState() {
    super.initState();

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

  @override
  void dispose() {
    scanResultsSubscription.cancel();
    isScanningSubscription.cancel();
    super.dispose();
  }
  Future onScanPressed() async {
    try {
      // `withServices` is required on iOS for privacy purposes, ignored on android.
      var withServices = [Guid("180f")]; // Battery Level Service
      systemDevices = await FlutterBluePlus.systemDevices(withServices);
    } catch (e) {
      print(e);
    }
    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
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

    /*if(setupComplete)
      {
        Navigator.pop(context);
        Navigator.push(context,MaterialPageRoute(builder: (context) => ValveSettings()));
      }*/
    return Scaffold
      (
        appBar: AppBar(
          toolbarHeight: currentHeight *0.1,
          title: Text('Lush Universal Irrigater', style: LuiTextTheme.luiH1),
          backgroundColor: Colors.cyan[300]
          ,
        ),
        body: Container(
          width: currentWidth,
          height: currentHeight,
          child: setupBegin ? AvailableDevices(context)  : initialSetup(
              context),

        )

    );
  }

  Widget initialSetup(BuildContext context) {
    double currentHeight = MediaQuery
        .of(context)
        .size
        .height;
    double currentWidth = MediaQuery
        .of(context)
        .size
        .width;
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children:
          [
            SizedBox(height: currentHeight * 0.30),
            Text('Welcome to LUI!', style: LuiTextTheme.luiH1,),
            SizedBox(height: currentHeight * 0.05),
            // Adds spacing between widgets
            Text('Click the button below to begin setup',
              style: LuiTextTheme.luiT1,),
            SizedBox(height: currentHeight * 0.03),
            ElevatedButton(onPressed: () {
              setState(() {
                setupBegin = true;
              });
            }, child: Text('Press Me', style: LuiTextTheme.luiT1)),
          ]
      ),);
  }



  /*Widget valveSetupLoading(BuildContext context)
  {
    return Center(
      child: AvailableDevices(
          context)
    );
  }*/

  Widget AvailableDevices(BuildContext context) {
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
                                        controller.connectToDevice(data.device, context),
                                      setupComplete = true,
                                        SystemInfoHandler().setSetUpStatus(setupComplete),
                                        Navigator.push(context,MaterialPageRoute(builder: (context) => ValveSettings()))
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