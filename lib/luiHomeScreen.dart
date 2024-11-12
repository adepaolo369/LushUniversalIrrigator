import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lui_project/common/styles.dart';
import 'package:lui_project/common/systemVars.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:lui_project/common/bluetoothFunction.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget
{
  @override
  HomeScreenState createState() => HomeScreenState();

}

class HomeScreenState extends State<HomeScreen> {
  bool setupComplete = false; //SystemInfoHandler().isSetupComplete();
  bool deviceSetupLoad = true;

  List<BluetoothDevice> devicesList = [];
  List<ScanResult> scanResults = [];

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
    return Scaffold
      (
        appBar: AppBar(
          title: Text('Lush Universal Irrigater', style: LuiTextTheme.luiH1),
          backgroundColor: Colors.cyan[300]
          ,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: (setupComplete) ? valveSetupLoading(context) : initialSetup(
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
                setupComplete = true;
                AvailableDevices(context);
              });
            }, child: Text('Press Me', style: LuiTextTheme.luiT1)),
          ]
      ),);
  }



  Widget valveSetupLoading(BuildContext context)
  {
    return Center(
      child: AvailableDevices(
          context)
    );
  }

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
                        if (snapshot.hasData) {
                          return Expanded(
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
                                      onTap: ()=> controller.connectToDevice(data.device),
                                    ),
                                  );
                                }),
                          );
                        }else{
                          return Center(child: Text("No Device Found"),);
                        }
                      }),
                  SizedBox(height: 10,),
                  ElevatedButton(onPressed: ()  async {
                    controller.scanDevices();
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