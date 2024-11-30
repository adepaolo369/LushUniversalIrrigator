import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
class SystemInfoHandler
{
   //Initialize variables to hold string keys for locations of the appropriate
   //system values.
   static const setupComplete = 'setupComp';
   static const deviceID = "deviceID";
   static const waterTimeHour = "waterTimeHour";
   static const waterTimeMinute = "waterTimeMinute";
   static const waterTimeDay = "waterTimeDay";

   //Create a single instance of shared preferences to store all the data with.
   static SharedPreferences? prefs;

   //Creates a singleton pattern to only create a single instance of the System Info Handler.
   static final SystemInfoHandler instance = SystemInfoHandler._internal();
   factory SystemInfoHandler()
   {
      return instance;
   }
   SystemInfoHandler._internal();
   //Future function to initialize pref variable to the system instance of shared preferences.
   static Future<void> init() async
   {
      prefs = await SharedPreferences.getInstance();
   }

   //Method that saves the values for the automatic watering time to system memory.
   Future<void> setTime( int hours, int minutes, int day)
   async
   {
      await prefs?.setInt(waterTimeHour, hours);
      await prefs?.setInt(waterTimeMinute, minutes);
      await prefs?.setInt(waterTimeDay, day);
   }

   //Returns the time saved in system memory.
   List<int> getTime()
   {
      List<int> getTime = [prefs?.getInt(waterTimeHour) ?? 0,prefs?.getInt(waterTimeMinute) ?? 0,prefs?.getInt(waterTimeDay) ?? 0 ];
      return getTime;
   }

   //Checks if the device setup has been complete in system memory.
   bool deviceSetupComplete()
   {
      return prefs?.getBool(setupComplete) ?? false;
   }

   // Save boolean value.
   Future<void> setSetUpStatus(bool setupValue) async {
      await prefs?.setBool(setupComplete, setupValue);
   }

   // Retrieve boolean value.
   bool isSetupComplete()
   {
      return prefs?.getBool(setupComplete) ?? false;
   }

   // Saves a bluetooth ID to system memory
   Future<void> saveDeviceID(String dID) async
   {
      await prefs?.setString(deviceID, dID);
   }
   //Gets the bluetooth device ID from the system memory.
   String? getDeviceID()
   {
      return prefs?.getString(deviceID);
   }

   //Clears the device ID from system memory.
   static Future<void> clearDeviceID() async
   {
      await prefs?.remove(deviceID);
   }

   //Saves the list of valves passed to it to system memory in the form of a list of JSON strings.
   Future<void> saveValves(List<Valve> valvesIn) async
   {

      // Convert the List<Valve> to a List<Map> and then to a JSON String.
      List<String> valveStringList = valvesIn.map((valve) => jsonEncode(valve.toJson())).toList();

      // Save the JSON string to SharedPreferences.
      await prefs?.setStringList("valves_list", valveStringList);
   }

   // Add a new item to the list and save it
   Future<void> addValve(Valve newValve) async
   {
      List<Valve> valves = getValves(); // Load the current list
      valves.add(newValve); // Add the new item
      await saveValves(valves); // Save the updated list back to SharedPreferences
   }


   //Get the list of saved vales from memory.
   List<Valve> getValves()
   {
      // Get the JSON string from SharedPreferences.
      List<String>? jsonStringList = prefs?.getStringList("valves_list");

      //If the json list exists in memory, get it and return it.
      if (jsonStringList != null)
      {
         // Decode the JSON string into a List of Maps.
         List<Valve>? finalList = jsonStringList.map((valve) => Valve.fromJson(json.decode(valve))).toList();
         return finalList;
      }

      //If list of valves doesn't exist or is empty, return an empty list.
      return [];
   }


   // Clear the stored list
   Future<void> clearValves() async
   {
      await prefs?.remove("valves_list");
   }

   Future<void> deleteValve(int valveIDToDelete) async
   {
      List<Valve> changeList = getValves();
      int index = changeList.indexWhere((valve) => valve.valveID == valveIDToDelete);

      changeList.removeAt(index);

      saveValves(changeList);
   }

}



class Valve
{
   int valveID;
   int waterAmountManual;
   int waterAmountAutomatic;
   int actualWaterAmount;
   bool inUse = true;
   bool mode = true;


   //
   Valve({required this.valveID,required this.waterAmountManual,required this.waterAmountAutomatic, required this.actualWaterAmount, required this.inUse, required this.mode});

   // Convert a valve object to a Map (for JSON encoding).
   Map<String, dynamic> toJson() => {
      'valveID' : valveID,
      'waterAmountManual': waterAmountManual,
      'waterAmountAutomatic': waterAmountAutomatic,
      'actualWaterAmount' : actualWaterAmount,
      'inUse' : inUse,
      'mode' : mode,
   };

   // Convert a Map to a Valve object (for JSON decoding).
   factory Valve.fromJson(Map<String, dynamic> json)
   {
      return Valve(
         valveID: json['valveID'] ?? 0,
         waterAmountManual: json['waterAmountManual'] ?? 0,
         waterAmountAutomatic: json['waterAmountAutomatic'] ?? 0,
         actualWaterAmount: json['actualWaterAmount'] ?? 0,
         inUse: json['inUse'] ?? true,
         mode: json['mode'] ?? true,
      );
   }
}