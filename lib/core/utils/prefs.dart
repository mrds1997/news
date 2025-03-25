import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data_store_keys.dart';
class Prefs{

  static SharedPreferences? _storage;

  static FlutterSecureStorage? _secureStorage;

  static void init() async{
    _storage ??= await SharedPreferences.getInstance();
    _secureStorage ??= const FlutterSecureStorage();
  }


  /*static void setPassCode(String? passCode) async{
    await _secureStorage?.write(key: DataStoreKeys.passCode, value: passCode);
  }

  static Future<String> getPassCode() async {
    String? value;
    value = await _secureStorage?.read(key: DataStoreKeys.passCode);

    return value ?? "";
  }*/


}