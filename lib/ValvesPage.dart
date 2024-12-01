import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:lui_project/settingPage.dart';
import '/common/styles.dart';
import 'package:flutter/services.dart';
import 'package:lui_project/luiInitialSetup.dart';
import 'package:lui_project/common/systemVars.dart';
import 'package:lui_project/common/bluetoothFunction.dart';
import 'package:lui_project/common/Global.dart';
import 'package:lui_project/ValveSettingsPage.dart';
final TextEditingController timeController = TextEditingController();
final TextEditingController waterAmountController = TextEditingController();
final TextEditingController valveIdSetController = TextEditingController();




class ValvePage extends StatefulWidget {
  @override
  ValvePageState createState() => ValvePageState();
}

class ValvePageState extends State<ValvePage>
{
  late bool amPM;
  late int globalHour;
  late int intAMPM;


  @override
  void initState() {
    super.initState();
    valveLoad();
    connectAndUpdateAll(context);
    globalHour = SystemInfoHandler().getTime()[0];
    if(globalHour > 11) {
      amPM = true;
    }
    if(globalHour <= 11) {
      amPM = false;
    }
    if(amPM){
      intAMPM = 1;
    }
    else{
      intAMPM = 0;
    }

    if(SystemInfoHandler().getTime()[0] <= 0){
      globalHour = 11;
    }
    if(SystemInfoHandler().getTime()[0] > 0 && SystemInfoHandler().getTime()[0] <= 12){
      globalHour = SystemInfoHandler().getTime()[0] - 1;
    }
    if(SystemInfoHandler().getTime()[0] > 12){
      globalHour = SystemInfoHandler().getTime()[0] - 12;
    }
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
          children: [
            Text('Your Valves', style: LuiTextTheme.luiH1),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),

          ],
        ),
        backgroundColor: Colors.cyan[300],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.cyan[200],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    print("Writing value: '1' to all refill uuid");
                    BleController().writeBoolCharacteristic('1', '19b10001-e8f2-537e-4f6c-d104768a1259');
                    BleController().writeBoolCharacteristic('1', '19b10001-e8f2-537e-4f6c-d104768a1260');
                    BleController().writeBoolCharacteristic('1', '19b10001-e8f2-537e-4f6c-d104768a1261');
                    BleController().writeBoolCharacteristic('1', '19b10001-e8f2-537e-4f6c-d104768a1262');
                    BleController().writeBoolCharacteristic('1', '19b10001-e8f2-537e-4f6c-d104768a1263');
                    BleController().writeBoolCharacteristic('1', '19b10001-e8f2-537e-4f6c-d104768a1264');
                    BleController().writeBoolCharacteristic('1', '19b10001-e8f2-537e-4f6c-d104768a1265');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[300],
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                      "All Refilled",
                      style: TextStyle(fontSize: 18, color: Colors.white,fontWeight: FontWeight.bold)
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showTimeSetDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[300],
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                      "Water Time",
                      style: TextStyle(fontSize: 18, color: Colors.white,fontWeight: FontWeight.bold)
                  ),
                ), ////
              ],
            ),
          ),
        SizedBox(height: 16),
        // Expanded ListView to display valve items
        Expanded(
          child: ListView.builder(
            itemCount: globalLocalList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    globalIndex =index;
                    Navigator.push(context,MaterialPageRoute(builder: (context) => ValveSettings()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.cyan[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      "Valve: ${globalLocalList[index].valveID}, Water Amount: ${globalLocalList[index].waterAmountAutomatic}",
                      style: TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 10), // Space between ListView and button
        // Add button styled like a list item
        GestureDetector(
          onTap: () {
            // Use the current instance to show the dialog
            showAddValveDialog(context);
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.green[300],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Icon(
                Icons.add,
                size: 28.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    ),
    );
  }


  void showAddValveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add New Valve"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: valveIdSetController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Valve ID"),
              ),
              TextField(
                controller: waterAmountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Water Amount"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without saving
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                int waterAmount = int.tryParse(waterAmountController.text) ?? 0;
                int valveIDSet = int.tryParse(valveIdSetController.text) ?? 0;

                if (waterAmount < 0){
                  waterAmount = 0;
                }
                if (valveIDSet < 1){
                  valveIDSet = 1;
                }
                if (valveIDSet > 7){
                  valveIDSet = 7;
                }
                bool valveAlreadyExistsWithID = false;
                for(int currentIndex = 0; currentIndex < globalLocalList.length; currentIndex++) {
                  if(globalLocalList[currentIndex].valveID == valveIDSet) {
                    valveAlreadyExistsWithID = true;
                    break;
                  }
                }

                if (valveAlreadyExistsWithID){
                  Navigator.of(context).pop(); // Close dialog
                  // Clear input fields
                  timeController.clear();
                  waterAmountController.clear();
                }
                else{
                  // Add the new valve item to the list
                  setState(() {
                    Valve currentValve = Valve(
                        valveID: valveIDSet, // Set ID
                        waterAmountAutomatic: waterAmount, waterAmountManual: 0, actualWaterAmount: 0, inUse: true, mode: true);
                    globalLocalList.add(currentValve);
                    SystemInfoHandler().addValve(currentValve);
                  });
                  Navigator.of(context).pop(); // Close dialog
                  // Clear input fields
                  timeController.clear();
                  waterAmountController.clear();
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }
  void showTimeSetDialog(BuildContext context) {
    final List<int> minutesList = List.generate(60, (index) => index);
    final List<int> hoursList = List.generate(12, (index) => index + 1);
    final List<String> amPMList = ['AM' , 'PM'];
    final List<String> dayList = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat','Sun'];
    final FixedExtentScrollController hourController = FixedExtentScrollController(initialItem: globalHour );
    final FixedExtentScrollController minuteController = FixedExtentScrollController(initialItem: SystemInfoHandler().getTime()[1]);
    final FixedExtentScrollController amPMController = FixedExtentScrollController(initialItem: intAMPM);
    final FixedExtentScrollController dayController = FixedExtentScrollController(initialItem: (SystemInfoHandler().getTime()[2] - 1));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Set Water Time"),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 70,
                height: 145,
                child: ListWheelScrollView.useDelegate(
                  controller: hourController,
                  itemExtent: 50,
                  perspective: 0.005,
                  diameterRatio: 1.5,
                  physics: FixedExtentScrollPhysics(),
                  childDelegate: ListWheelChildBuilderDelegate(
                      childCount: 12,
                      builder: (context,index){
                        return Center(
                          child: Text(
                            '${hoursList[index]}',
                            style: TextStyle(fontSize: 32),
                          ),

                        );
                      }
                  ),
                ),
              ),
              Text(
                ":",
                style: TextStyle(fontSize: 32),
              ),
              Container(
                width: 70,
                height: 145,
                child: ListWheelScrollView.useDelegate(
                  controller: minuteController,
                  itemExtent: 50,
                  perspective: 0.005,
                  diameterRatio: 1.5,
                  physics: FixedExtentScrollPhysics(),
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: 60,
                    builder: (context,index){
                      return Center(
                        child: Text(
                          '${minutesList[index]}',
                          style: TextStyle(fontSize: 32),
                        ),

                      );
                    }
                  ),
                ),
              ),
              Container(
                width: 70,
                height: 145,
                child: ListWheelScrollView.useDelegate(
                  controller: amPMController,
                  itemExtent: 50,
                  perspective: 0.005,
                  diameterRatio: 1.5,
                  physics: FixedExtentScrollPhysics(),
                  childDelegate: ListWheelChildBuilderDelegate(
                      childCount: 2,
                      builder: (context,index){
                        return Center(
                          child: Text(
                            amPMList[index],
                            style: TextStyle(fontSize: 32),
                          ),

                        );
                      }
                  ),
                ),
              ),
              Container(
                width: 70,
                height: 145,

                child: ListWheelScrollView.useDelegate(
                  controller: dayController,
                  itemExtent: 50,
                  perspective: 0.005,
                  diameterRatio: 1.5,
                  physics: FixedExtentScrollPhysics(),
                  childDelegate: ListWheelChildBuilderDelegate(
                      childCount: 7,
                      builder: (context,index){
                        return Center(
                          child: Text(
                            dayList[index],
                            style: TextStyle(fontSize: 32),
                          ),

                        );
                      }
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without saving
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                late int calcHours;
                if((hourController.selectedItem + 1) == 12 && amPMController.selectedItem == 0 ){
                  calcHours = 0;
                }
                else if((hourController.selectedItem + 1) < 12 && amPMController.selectedItem == 0) {
                  calcHours =  hourController.selectedItem + 1;
                }
                else if((hourController.selectedItem + 1) == 12 && amPMController.selectedItem == 1){
                  calcHours = 12;
                }
                else if((hourController.selectedItem + 1) < 12 && amPMController.selectedItem == 1){
                  calcHours = hourController.selectedItem + 13;
                }
                intAMPM = amPMController.selectedItem;
                globalHour = hourController.selectedItem;

                SystemInfoHandler().setTime(calcHours,minuteController.selectedItem,(dayController.selectedItem + 1));
                BleController().writeIntCharacteristic(calcHours.toString(), '19b10001-e8f2-537e-4f6c-d104768a1250');
                BleController().writeIntCharacteristic(minuteController.selectedItem.toString(), '19b10001-e8f2-537e-4f6c-d104768a1251');
                BleController().writeIntCharacteristic((dayController.selectedItem + 1 ).toString(), '19b10001-e8f2-537e-4f6c-d104768a1273');

                Navigator.of(context).pop(); // Close dialog
              },
              child: Text("Set"),
            ),
          ],
        );
      },
    );
  }

}



void valveLoad()
{
  globalLocalList =  SystemInfoHandler().getValves();
  if(globalLocalList.isEmpty)
    {
      globalLocalList=[];
    }
  return;
}
void updateTime() {
  final now = DateTime.now();
  BleController().writeIntCharacteristic(now.second.toString(), '19b10001-e8f2-537e-4f6c-d104768a1247');
  BleController().writeIntCharacteristic(now.minute.toString(), '19b10001-e8f2-537e-4f6c-d104768a1246');
  BleController().writeIntCharacteristic(now.hour.toString(), '19b10001-e8f2-537e-4f6c-d104768a1245');
  BleController().writeIntCharacteristic(now.day.toString(), '19b10001-e8f2-537e-4f6c-d104768a1242');
  BleController().writeIntCharacteristic(now.month.toString(), '19b10001-e8f2-537e-4f6c-d104768a1243');
  BleController().writeIntCharacteristic(now.year.toString(), '19b10001-e8f2-537e-4f6c-d104768a1244');
  BleController().writeIntCharacteristic(now.weekday.toString(), '19b10001-e8f2-537e-4f6c-d104768a1248');
  BleController().writeBoolCharacteristic('1', '19b10001-e8f2-537e-4f6c-d104768a1275');
  return;
}

void sendValveData() {
  for(int currentIndex =0; currentIndex < globalLocalList.length; currentIndex++) {
    if (globalLocalList[currentIndex].valveID == 1) {
      if (globalLocalList[currentIndex].inUse) {
        BleController().writeBoolCharacteristic(
            '1', '19b10001-e8f2-537e-4f6c-d104768a1214');
      }
      else {
        BleController().writeBoolCharacteristic(
            '0', '19b10001-e8f2-537e-4f6c-d104768a1214');
      }

      BleController().writeIntCharacteristic(
          globalLocalList[currentIndex].actualWaterAmount.toString(),
          '19b10001-e8f2-537e-4f6c-d104768a1235');
      BleController().writeIntCharacteristic(
          globalLocalList[currentIndex].waterAmountAutomatic.toString(),
          '19b10001-e8f2-537e-4f6c-d104768a1228');
      BleController().writeIntCharacteristic(
          globalLocalList[currentIndex].waterAmountManual.toString(),
          '19b10001-e8f2-537e-4f6c-d104768a1266');
    }

    if (globalLocalList[currentIndex].valveID == 2) {
      if (globalLocalList[currentIndex].inUse) {
        BleController().writeBoolCharacteristic(
            '1', '19b10001-e8f2-537e-4f6c-d104768a1215');
      }
      else {
        BleController().writeBoolCharacteristic(
            '0', '19b10001-e8f2-537e-4f6c-d104768a1215');
      }

      BleController().writeIntCharacteristic(
          globalLocalList[currentIndex].actualWaterAmount.toString(),
          '19b10001-e8f2-537e-4f6c-d104768a1236');
      BleController().writeIntCharacteristic(
          globalLocalList[currentIndex].waterAmountAutomatic.toString(),
          '19b10001-e8f2-537e-4f6c-d104768a1229');
      BleController().writeIntCharacteristic(
          globalLocalList[currentIndex].waterAmountManual.toString(),
          '19b10001-e8f2-537e-4f6c-d104768a1267');
    }

    if (globalLocalList[currentIndex].valveID == 3) {
      if (globalLocalList[currentIndex].inUse) {
        BleController().writeBoolCharacteristic(
            '1', '19b10001-e8f2-537e-4f6c-d104768a1216');
      }
      else {
        BleController().writeBoolCharacteristic(
            '0', '19b10001-e8f2-537e-4f6c-d104768a1216');
      }

      BleController().writeIntCharacteristic(
          globalLocalList[currentIndex].actualWaterAmount.toString(),
          '19b10001-e8f2-537e-4f6c-d104768a1237');
      BleController().writeIntCharacteristic(
          globalLocalList[currentIndex].waterAmountAutomatic.toString(),
          '19b10001-e8f2-537e-4f6c-d104768a1230');
      BleController().writeIntCharacteristic(
          globalLocalList[currentIndex].waterAmountManual.toString(),
          '19b10001-e8f2-537e-4f6c-d104768a1268');
    }

    if (globalLocalList[currentIndex].valveID == 4) {
      if (globalLocalList[currentIndex].inUse) {
        BleController().writeBoolCharacteristic(
            '1', '19b10001-e8f2-537e-4f6c-d104768a1217');
      }
      else {
        BleController().writeBoolCharacteristic(
            '0', '19b10001-e8f2-537e-4f6c-d104768a1217');
      }

      BleController().writeIntCharacteristic(
          globalLocalList[currentIndex].actualWaterAmount.toString(),
          '19b10001-e8f2-537e-4f6c-d104768a1238');
      BleController().writeIntCharacteristic(
          globalLocalList[currentIndex].waterAmountAutomatic.toString(),
          '19b10001-e8f2-537e-4f6c-d104768a1231');
      BleController().writeIntCharacteristic(
          globalLocalList[currentIndex].waterAmountManual.toString(),
          '19b10001-e8f2-537e-4f6c-d104768a1269');
    }
    if (globalLocalList[currentIndex].valveID == 5) {
      if (globalLocalList[currentIndex].inUse) {
        BleController().writeBoolCharacteristic(
            '1', '19b10001-e8f2-537e-4f6c-d104768a1218');
      }
      else {
        BleController().writeBoolCharacteristic(
            '0', '19b10001-e8f2-537e-4f6c-d104768a1218');
      }

      BleController().writeIntCharacteristic(
          globalLocalList[currentIndex].actualWaterAmount.toString(),
          '19b10001-e8f2-537e-4f6c-d104768a1239');
      BleController().writeIntCharacteristic(
          globalLocalList[currentIndex].waterAmountAutomatic.toString(),
          '19b10001-e8f2-537e-4f6c-d104768a1232');
      BleController().writeIntCharacteristic(
          globalLocalList[currentIndex].waterAmountManual.toString(),
          '19b10001-e8f2-537e-4f6c-d104768a1270');
    }

    if (globalLocalList[currentIndex].valveID == 6) {
      if (globalLocalList[currentIndex].inUse) {
        BleController().writeBoolCharacteristic(
            '1', '19b10001-e8f2-537e-4f6c-d104768a1219');
      }
      else {
        BleController().writeBoolCharacteristic(
            '0', '19b10001-e8f2-537e-4f6c-d104768a1219');
      }

      BleController().writeIntCharacteristic(
          globalLocalList[currentIndex].actualWaterAmount.toString(),
          '19b10001-e8f2-537e-4f6c-d104768a1240');
      BleController().writeIntCharacteristic(
          globalLocalList[currentIndex].waterAmountAutomatic.toString(),
          '19b10001-e8f2-537e-4f6c-d104768a1233');
      BleController().writeIntCharacteristic(
          globalLocalList[currentIndex].waterAmountManual.toString(),
          '19b10001-e8f2-537e-4f6c-d104768a1271');
    }

    if (globalLocalList[currentIndex].valveID == 7) {
      if (globalLocalList[currentIndex].inUse) {
        BleController().writeBoolCharacteristic(
            '1', '19b10001-e8f2-537e-4f6c-d104768a1220');
      }
      else {
        BleController().writeBoolCharacteristic(
            '0', '19b10001-e8f2-537e-4f6c-d104768a1220');
      }

      BleController().writeIntCharacteristic(
          globalLocalList[currentIndex].actualWaterAmount.toString(),
          '19b10001-e8f2-537e-4f6c-d104768a1241');
      BleController().writeIntCharacteristic(
          globalLocalList[currentIndex].waterAmountAutomatic.toString(),
          '19b10001-e8f2-537e-4f6c-d104768a1234');
      BleController().writeIntCharacteristic(
          globalLocalList[currentIndex].waterAmountManual.toString(),
          '19b10001-e8f2-537e-4f6c-d104768a1272');
    }
  }

  return;
}

void sendWaterTime() {
  BleController().writeIntCharacteristic(SystemInfoHandler().getTime()[0].toString(),'19b10001-e8f2-537e-4f6c-d104768a1250');
  BleController().writeIntCharacteristic(SystemInfoHandler().getTime()[1].toString(),'19b10001-e8f2-537e-4f6c-d104768a1251');
  BleController().writeIntCharacteristic(SystemInfoHandler().getTime()[2].toString(),'19b10001-e8f2-537e-4f6c-d104768a1273');
  return;
}

Future<void> connectAndUpdateAll(BuildContext context) async
{
  BluetoothDevice device = BluetoothDevice.fromId(SystemInfoHandler().getDeviceID() ?? "none");
  if(device.isDisconnected)
  {

    await BleController().connectToDevice(device, context);

  }
  updateTime();
  sendValveData();
  sendWaterTime();
}
