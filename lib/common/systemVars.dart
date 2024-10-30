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


   Future<void> saveValves(List<Valve> valves) async
   {
      final prefs = await SharedPreferences.getInstance();

      // Convert the List<Valve> to a List<Map> and then to a JSON String.
      String jsonString = jsonEncode(valves.map((valve) => valve.toJson()).toList());

      // Save the JSON string to SharedPreferences.
      await prefs.setString('valves', jsonString);
   }

   Future<List<Valve>> getValves() async
   {
      final prefs = await SharedPreferences.getInstance();

      // Get the JSON string from SharedPreferences.
      String? jsonString = prefs.getString('users');

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
}



class Valve
{
   int time ;
   int waterAmount;

   //
   Valve({required this.time, required this.waterAmount});

   // Convert a valve object to a Map (for JSON encoding).
   Map<String, dynamic> toJson() => {
      'time': time,
      'waterAmount': waterAmount,
   };

   // Convert a Map to a Valve object (for JSON decoding).
   factory Valve.fromJson(Map<String, dynamic> json)
   {
      return Valve(
         time: json['time'],
         waterAmount: json['waterAmount'],
      );
   }
}
