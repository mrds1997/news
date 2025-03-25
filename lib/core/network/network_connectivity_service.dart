import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class NetworkConnectivityService{

  static Future<bool> hasInternet() async {
    // First check if the device is connected to any network
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;  // No network connection
    }

    // Now check for actual internet access
    if(kIsWeb){
      return true;
    }
    try {
      //ToDo
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;  // Internet is available
      }
    } on SocketException catch (_) {
      return false;  // No internet access, even if connected to a network
    }

    return false;  // Default to false if any failure occurs
  }
}