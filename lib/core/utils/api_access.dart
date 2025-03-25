import 'dart:collection';
import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http_parser/http_parser.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/shared/types.dart';
import '../../main.dart';
import '../models/error_response.dart';
import '../network/network_connectivity_service.dart';
import 'data_store_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import 'logout_exception.dart';

class ApiAccess {
  ApiAccess._privateConstructor();

  static final ApiAccess _instance = ApiAccess._privateConstructor();

  static ApiAccess get instance => _instance;

  //ApiAccess(this.context);

  FlutterSecureStorage? _secureStorage;
  SharedPreferences? _storage;
  String? accessToken = '';
  String apiSecret = '';
  String valId = '';
  late String timeStamp;
  static const String HEXES = "0123456789abcdef";
  static const int DEFAULT_TIMEOUT = 120 * 1000;
  static const String API_KEY_HEADER = "API-KEY";
  static const String API_SIGNATURE_HEADER = "X-HASH";
  static const String TIME_STAMP_HEADER = "API-REQUEST-TIME";
  static const String AUTHORIZATION_HEADER = "Authorization";
  static const String COOKIE_HEADER = "Cookie";
  static const String Content_Type_HEADER = "Content-Type";

  Future<http.Response?> makeHttpRequest(
    String url, {
    required Method method,
    required Map<String, dynamic>? params,
  }) async {
    _secureStorage ??= const FlutterSecureStorage();
    _storage ??= await SharedPreferences.getInstance();

    //ToDo get apiKey fro secure storage

    /*if(!kIsWeb){
      if (_secureStorage!.read(key: DataStoreKeys.accessToken) != null) {
        accessToken = await _secureStorage!.read(key: DataStoreKeys.accessToken);
      }
    } else {
      if (_storage!.getString(DataStoreKeys.accessToken) != null) {
        accessToken = _storage!.getString(DataStoreKeys.accessToken);
      }
    }*/


    //debugger();

    log("accessToken : ${accessToken}");


    timeStamp = DateTime.now().millisecondsSinceEpoch.toString();

    // Map<String, String> headers = kIsWeb ? getHeaderPWA() : getHeader();
    //Map<String, String> headers = getHeader();

    log("Api Request to $url : $params in ${method.name}");

    http.Response response;

    bool hasInternet = await NetworkConnectivityService.hasInternet();

    Future<http.Response?> data() async {

      ErrorResponseModel errorResponse = ErrorResponseModel(
        status: "no ok",
        message: 'No internet connection',
        code: "485"
      );

      // Convert the error model to JSON and return it as the response body
      String errorBody = json.encode({
        'success': errorResponse.status,
        'message': errorResponse.message,
      });

      return http.Response(errorBody, 408);
    }

    if (!hasInternet) {
      return data();
    }
    if (method == Method.GET) {
      Uri uri;
      if (params == null) {
        uri = Uri.parse(url);
      } else {
        uri = Uri.parse(url).replace(queryParameters: params);
      }
      response = await http.get(uri).timeout(Duration(milliseconds: DEFAULT_TIMEOUT),);

      log("API Response code GET Method : ${response.statusCode}");

      log("Api Response of GET Method ($url) : ${response.body}");
    } else {
      var uri = Uri.parse(url);
      response = await http.post(uri, body: json.encode(params ?? {}),).timeout(const Duration(milliseconds: DEFAULT_TIMEOUT));
      log("Api Response of ($url) : ${response.body}");
      log("API Response code : ${response.statusCode}");
    }

    return response;
  }

  Map<String, String> getHeader() {
    var r = {
      Content_Type_HEADER: "application/json",
      AUTHORIZATION_HEADER: "Bearer $accessToken",
      COOKIE_HEADER: "access_token=$accessToken",
    };
    return r;
  }

  Map<String, String> getHeaderPWA() {
    var r = {
      Content_Type_HEADER: "application/json",
    };
    return r;
  }

  Map<String, String> getHeaderUpload() {
    var r = {
      Content_Type_HEADER: "multipart/form-data",
      AUTHORIZATION_HEADER: "Bearer $accessToken",
      COOKIE_HEADER: "access_token=$accessToken",
    };
    return r;
  }
}
enum Method { POST, GET, PUT, DELETE, UPDATE }
