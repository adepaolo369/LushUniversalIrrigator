import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:shared_preferences/shared_preferences.dart';

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