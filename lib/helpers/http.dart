import 'dart:convert';
import 'dart:developer' as d;

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HTTP {
  static final HTTP _instance = HTTP._internal();
  HTTP._internal() {
    _httpClient = http.Client();
  }

  factory HTTP() => _instance;

  Map<String, String>? _headers;

  late http.Client _httpClient;

  http.Client getHttpClient() {
    return _httpClient;
  }

  void closeClient() {
    // if (_httpClient != null) {
    _httpClient.close();
    // }
  }

  Map<String, String>? getHeadersWeb() {
    // _headers["charset"] = "utf-8";
    _headers = <String, String>{
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token",
      "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
    };
    // _headers["content-type"] = "application/x-www-form-urlencoded";
    // _headers["Content-Type"] = "application/x-www-form-urlencoded";
    return _headers;
  }

  Future<Map<String, String>> getHeaders() async {
    if (_headers == null) {
      _headers = {};
      _headers!["content-type"] = "application/json";
      _headers!["Accept"] = "application/json";
      _headers!["Access-Control-Allow-Origin"] = "*";
      _headers!["Access-Control-Allow-Methods"] = "GET,POST,OPTIONS";
      _headers!["Access-Control-Allow-Credentials"] = "true";
      _headers!["Origin"] = "https://masalabazaar.azurewebsites.net";
      _headers!["Access-Control-Allow-Headers"] =
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token";
    }

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // ignore: prefer_collection_literals
    if (sharedPreferences.containsKey('cookie')) {
      var header = sharedPreferences.getString('cookie');
      if (header != null) {
        _headers!["cookie"] = header;
      }
    }
    if (sharedPreferences.containsKey('authorization')) {
      var header = sharedPreferences.getString('authorization');
      if (header != null) {
        _headers!["Authorization"] = header;
      }
    }

    return _headers!;
  }

  Future<dynamic> post(String url, body) async {
    try {
      Map<String, String> headers = await getHeaders();
      return await getHttpClient()
          .post(Uri.parse(url), headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 50000));
    } catch (e) {
      d.log("HTTP [POST ERROR] :", error: e);
      return Future.value(
        http.Response(
          jsonEncode({"Success": false, "Message": e.toString()}),
          400,
        ),
      );
    }
  }

  Future<dynamic> get(String url) async {
    try {
      Map<String, String> headers = await getHeaders();
      return getHttpClient()
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 50000));
    } catch (e) {
      return Future.value(
        http.Response(
          jsonEncode({"Success": false, "Message": e.toString()}),
          400,
        ),
      );
    }
  }

  Future<http.Response> webPost(String url, dynamic body) {
    try {
      return getHttpClient()
          .post(
            Uri.parse(url),
            headers: {
              "content-type": "application/json",
              "Access-Control-Allow-Origin": "*",
              "Access-Control-Allow-Credentials": "true",
              "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
              "Access-Control-Allow-Headers":
                  "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token",
              "Origin": "localhost:8080",
            },
            body: json.encode(body),
          )
          .timeout(const Duration(seconds: 50000));
    } catch (e) {
      d.log("HTTP [WEB_POST ERROR] :", error: e);
      return Future.value(
        http.Response(
          jsonEncode({"Success": false, "Message": e.toString()}),
          400,
        ),
      );
    }
  }

  //
}
