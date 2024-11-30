import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:lui_project/common/systemVars.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';

import 'bluetoothFunction.dart';


/*Global variables for holding desired watering time, bluetooth device services,
local valve list, and global current valve index.*/
List<BluetoothService> servicesGlobal = [];
late DateTime timeDesired;
List<Valve> globalLocalList = [];
late int globalIndex;
BluetoothStatusIndicator overallBluth = BluetoothStatusIndicator();