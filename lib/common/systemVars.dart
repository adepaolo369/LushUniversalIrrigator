import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
class SystemInfoHandler
{
   static const setupComplete = 'setupComp';
   static const deviceID = "deviceID";
   static const screenWidth = 0;
   static const screenHeight = 0;
   static List<String> valves = [];
   static SharedPreferences? prefs;

   static final SystemInfoHandler instance = SystemInfoHandler._internal();

   factory SystemInfoHandler()
   {
      return instance;
   }

   SystemInfoHandler._internal();

   static Future<void> init() async
   {
      prefs = await SharedPreferences.getInstance();
   }


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

   /// Save a Bluetooth device ID to SharedPreferences
    Future<void> saveDeviceID(String dID) async
   {
      await prefs?.setString(deviceID, dID);
   }
   /// Retrieve the Bluetooth device ID from SharedPreferences
    String? getDeviceID() {
      return prefs?.getString(deviceID);
   }

   /// Clear the Bluetooth device ID (optional)
   static Future<void> clearDeviceID() async {
      await prefs?.remove(deviceID);
   }

   /*static Future<void> saveScreenSize(int screenHeight, int screenWidth) async
   {
      await dataSaved?.setInt(screenHeight,screenHeight);
   }*/



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



   List<Valve> getValves()
   {
      // Get the JSON string from SharedPreferences.
      List<String>? jsonStringList = prefs?.getStringList("valves_list");

      if (jsonStringList != null)
      {
         // Decode the JSON string into a List of Maps.
         List<Valve>? finalList = jsonStringList.map((valve) => Valve.fromJson(json.decode(valve))).toList();
         return finalList;
      }

      //If list of valves is empty
      return [];
   }


   // Clear the stored list
   Future<void> clearValves() async
   {
      await prefs?.remove("valves_list");
   }
}



class Valve
{
   int valveID;
   int waterAmount;
   bool inUse = true;


   //
   Valve({required this.valveID,required this.waterAmount, required this.inUse});

   // Convert a valve object to a Map (for JSON encoding).
   Map<String, dynamic> toJson() => {
      'valveID' : valveID,
      'waterAmount': waterAmount,
      'inUse' : inUse,
   };

   // Convert a Map to a Valve object (for JSON decoding).
   factory Valve.fromJson(Map<String, dynamic> json)
   {
      return Valve(
         valveID: json['valveID'] ?? 0,
         waterAmount: json['waterAmount'] ?? 0,
         inUse: json['inUse'] ?? true,
      );
   }
}
