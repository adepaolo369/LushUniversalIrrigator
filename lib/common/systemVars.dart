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
   static const String valves = 'valves';
   static SharedPreferences? dataSaved;

   static final SystemInfoHandler instance = SystemInfoHandler._internal();

   factory SystemInfoHandler()
   {
      return instance;
   }

   SystemInfoHandler._internal();

   static Future<void> init() async
   {
      dataSaved = await SharedPreferences.getInstance();
   }


   bool deviceSetupComplete()
   {
      return dataSaved?.getBool(setupComplete) ?? false;
   }

   // Save boolean value.
   Future<void> setSetUpStatus(bool setupValue) async {
      await dataSaved?.setBool(setupComplete, setupValue);
   }

   // Retrieve boolean value.
   bool isSetupComplete()
   {
      return dataSaved?.getBool(setupComplete) ?? false;
   }

   /// Save a Bluetooth device ID to SharedPreferences
   static Future<void> saveDeviceID(String dID) async
   {
      await dataSaved?.setString(deviceID, dID);
   }
   /// Retrieve the Bluetooth device ID from SharedPreferences
   static String? getDeviceID() {
      return dataSaved?.getString(deviceID);
   }

   /// Clear the Bluetooth device ID (optional)
   static Future<void> clearDeviceID() async {
      await dataSaved?.remove(deviceID);
   }

   /*static Future<void> saveScreenSize(int screenHeight, int screenWidth) async
   {
      await dataSaved?.setInt(screenHeight,screenHeight);
   }*/



   Future<void> saveValves(List<Valve> valvesIn) async
   {
      final prefs = await SharedPreferences.getInstance();

      // Convert the List<Valve> to a List<Map> and then to a JSON String.
      String jsonString = jsonEncode(valvesIn.map((valve) => valve.toJson()).toList());

      // Save the JSON string to SharedPreferences.
      await prefs.setString(valves, jsonString);
   }

   // Add a new item to the list and save it
   Future<void> addItem(Valve newValve) async
   {
      List<Valve> valves = await getValves(); // Load the current list
      valves.add(newValve); // Add the new item
      await saveValves(valves); // Save the updated list back to SharedPreferences
   }



   Future<List<Valve>> getValves() async
   {
      final prefs = await SharedPreferences.getInstance();

      // Get the JSON string from SharedPreferences.
      String? jsonString = prefs.getString(valves);

      if (jsonString != null)
      {
         // Decode the JSON string into a List of Maps.
         List<dynamic> jsonList = jsonDecode(jsonString);

         // Convert each Map to a Valve object.
         return jsonList.map((json) => Valve.fromJson(json)).toList();
      }
      //If list of valves is empty
      return [];
   }


   // Clear the stored list
   Future<void> clearValves() async
   {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(valves);
   }
}



class Valve
{
   int valveID;
   int time ;
   int waterAmount;

   //
   Valve({required this.valveID, required this.time, required this.waterAmount});

   // Convert a valve object to a Map (for JSON encoding).
   Map<String, dynamic> toJson() => {
      'time': time,
      'waterAmount': waterAmount,
   };

   // Convert a Map to a Valve object (for JSON decoding).
   factory Valve.fromJson(Map<String, dynamic> json)
   {
      return Valve(
         valveID: json['valveID'],
         time: json['time'],
         waterAmount: json['waterAmount'],
      );
   }
}
