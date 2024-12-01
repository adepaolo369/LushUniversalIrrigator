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
      //Return a list of ints of the water time hour, minute, and second. If null then set to 0.
      List<int> getTime = [prefs?.getInt(waterTimeHour) ?? 0,prefs?.getInt(waterTimeMinute) ?? 0,prefs?.getInt(waterTimeDay) ?? 0 ];
      return getTime;
   }

   //Checks if the device setup has been complete in system memory.
   bool deviceSetupComplete()
   {
      return prefs?.getBool(setupComplete) ?? false;
   }

   // Save boolean value to the shared preferences memory at the key.
   Future<void> setSetUpStatus(bool setupValue) async {
      await prefs?.setBool(setupComplete, setupValue);
   }

   // Retrieve boolean value from memory.
   bool isSetupComplete()
   {
      return prefs?.getBool(setupComplete) ?? false;
   }

   // Saves a bluetooth ID to system memory.
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

      // Save the JSON string to the shared preferences memory under key "valve_list".
      await prefs?.setStringList("valves_list", valveStringList);
   }

   // Add a new valve to the valve list
   Future<void> addValve(Valve newValve) async
   {
      List<Valve> valves = getValves(); // Load the current list
      valves.add(newValve); // Add the new item
      await saveValves(valves); // Save the updated list back to the shared preferences memory.
   }


   //Get the list of saved valves from memory.
   List<Valve> getValves()
   {
      // Get the JSON string from the shared preferences memory.
      List<String>? jsonStringList = prefs?.getStringList("valves_list");

      //If the JSON string list exists return the list.
      if (jsonStringList != null)
      {
         // Decode the JSON string and map each inter their own valve object in a list.
         List<Valve>? finalList = jsonStringList.map((valve) => Valve.fromJson(json.decode(valve))).toList();
         //Return this list.
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

   //Delete a specific valve given its valveID
   Future<void> deleteValve(int valveIDToDelete) async
   {
      //Get the list of valves from memory and put it into a temporary list.
      List<Valve> changeList = getValves();
      //Get index of where the valve with the valveID is.
      int index = changeList.indexWhere((valve) => valve.valveID == valveIDToDelete);

      //Remove the valve at that index.
      changeList.removeAt(index);
      //Save the new list.
      saveValves(changeList);
   }

}


//Valve class that represents each valve connected to board.
class Valve
{
   //ValveID to identify the valve.
   int valveID;
   //Amount of water for valve to output during manual watering.
   int waterAmountManual;
   //Amount of water for valve to output during automatic watering.
   int waterAmountAutomatic;
   //Current amount of water inside the valves reservoir
   int actualWaterAmount;
   //Boolean variable to track use
   bool inUse = true;
   //Watering mode
   bool mode = true;


   //Valve constructor
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