import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lui_project/common/styles.dart';
import 'package:lui_project/common/systemVars.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:lui_project/common/bluetoothFunction.dart';
import 'package:get/get.dart';

import 'ValvesPage.dart';


//Initial Setup screen class, initialize a base state.
class InitialSetup extends StatefulWidget
{
  @override
  InitialSetupState createState() => InitialSetupState();

}

//Initial setup screen initial state class
class InitialSetupState extends State<InitialSetup>
{
  //Set of local bool variables to keep track of setup logic
  bool setupComplete = false;
  bool setupBegin = false;
  bool deviceSetupLoad = true;

  /*Initialize a local lists to hold the devices found by our bluetooth scan,
  * and hold the scan's results*/
  List<BluetoothDevice> systemDevices = [];
  List<ScanResult> scanResults = [];

  /*Create subscription stream for scanResults and bool variable for checking
  if it's working.*/
  bool isScanning = false;
  late StreamSubscription<List<ScanResult>> scanResultsSubscription;
  late StreamSubscription<bool> isScanningSubscription;

  //Initialize state with override.
  @override
  void initState()
  {
    super.initState();
    //Subscribe to the bluetooth scan results data stream to glean the results.
    scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      scanResults = results;
      if (mounted) {
        setState(() {});
      }
    }, onError: (e) {
    });
    //Subscribe to the bluetooth bool scan data stream to glean scan status.
    isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      isScanning = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

 //Local Bluetooth function for scanning
  Future onScanPressed() async {
    try {
      // `withServices` is required on iOS for privacy purposes, ignored on android.
      var withServices = [Guid("180f")]; // Battery Level Service

      //Get list of all bluetooth devices currently connected to the system with services
      systemDevices = await FlutterBluePlus.systemDevices(withServices);
    }
    catch (e)
    {
      print(e);
    }
    try {
      //Begin bluetooth scan with a timeout of 15 seconds, only show results with Arduino name.
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15), withNames: ["Valve Control"]);
    }
    catch (e)
    {
      print(e);
    }
    //If current widget is mounted, refresh to update the state to show results.
    if (mounted) {
      setState(() {});
    }
  }

  //On refresh of page, refresh the scan or else delay it.
  Future onRefresh() {
    if (isScanning == false) {
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    }
    if (mounted) {
      setState(() {});
    }
    return Future.delayed(Duration(milliseconds: 500));
  }


  //Main build of initial setup page widget.
  @override
  Widget build(BuildContext context)
  {
    //MediaQuery to get currentHeight and width in pixels of device's screen.
    double currentHeight = MediaQuery
        .of(context)
        .size
        .height;
    double currentWidth = MediaQuery
        .of(context)
        .size
        .width;

  //Scaffold to hold the entire page
    return Scaffold(
      //Appbar for title, scaled to 10% the current height and given a cyan background.
      appBar: AppBar(
        toolbarHeight: currentHeight *0.1,
        title: Text('Lush Universal Irrigater', style: LuiTextTheme.luiH1),
        backgroundColor: Colors.cyan[300],
        ),
      body: Container(
        width: currentWidth,
        height: currentHeight,
        //Check to see if this is the initial setup screen needs to be shown.
        child: setupBegin ? availableDevices(context)  : initialSetup(
              context),
        )
    );

  }

  //Initial setup widget that inherits the context of
  Widget initialSetup(BuildContext context)
  {
    //More mediaQuery checks
    double currentHeight = MediaQuery.of(context).size.height;
    double currentWidth = MediaQuery.of(context).size.width;

    //Create container to hold column to hold greetings and setup start button.
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
          Text('Click the button below to begin setup', style: LuiTextTheme.luiT1,),
          SizedBox(height: currentHeight * 0.03),
          ElevatedButton(
              onPressed: ()
              {
                setState(()
                {
                setupBegin = true;
                });
              },
              child: Text('Press Me', style: LuiTextTheme.luiT1)),
          ]
      ),
    );
  }



  //Widget for showing available bluetooth devices to connect to.
  Widget availableDevices(BuildContext context)
  {
    //Get currentheight and currentwidth.
    double currentHeight = MediaQuery.of(context).size.height;
    double currentWidth = MediaQuery.of(context).size.width;
    //Return scaffolding with title of Page
    return Scaffold(
        appBar: AppBar(title: Text("LUI Device Setup"),),
        //Get an instance of the bluetooth low energy controller
        body: GetBuilder<BleController>(
          //Initialize it
          init: BleController(),
          //Use the builder to create a list of the detected bluetooth devices
          builder: (BleController controller)
          {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                [
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
                                        setupComplete = true,
                                        SystemInfoHandler().setSetUpStatus(true),
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