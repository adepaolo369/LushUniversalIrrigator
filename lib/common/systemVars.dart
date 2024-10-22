import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
class SystemInfoHandler
{
   static const setupComplete = 'setupComp';
   static const deviceID = Null;


   static final SystemInfoHandler instance = SystemInfoHandler._internal();

   factory SystemInfoHandler()
   {
      return instance;
   }

   SystemInfoHandler._internal();



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
