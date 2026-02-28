import 'dart:convert';
import 'dart:developer' as d;
import '../helpers/http.dart';

class ApiService {
  final apiUrl = 'https://fakestoreapi.com';

  final HTTP http = HTTP();

  Future<ApiResponse> getProducts() async {
    try {
      final apiResponse = await http.get("$apiUrl/products");
      return _processApiResponse(apiResponse);
    } catch (e) {
      d.log("Error::ApiService::getProducts: ${e.toString()}");
      ApiResponse response = ApiResponse(success: false, message: e.toString());
      return Future.value(response);
    }
  }

  Future<ApiResponse> login(String username, String password) async {
    try {
      final apiResponse = await http.post("$apiUrl/auth/login", {
        "username": username,
        "password": password,
      });
      return _processApiResponse(apiResponse);
    } catch (e) {
      d.log("Error::ApiService::login: ${e.toString()}");
      ApiResponse response = ApiResponse(success: false, message: e.toString());
      return Future.value(response);
    }
  }

  static ApiResponse _processApiResponse(dynamic apiResponse) {
    try {
      if (apiResponse.statusCode != null) {
        if (apiResponse.statusCode == 200 || apiResponse.statusCode == 201) {
          var body = jsonDecode(apiResponse.body);
          var res = ApiResponse.fromJson({'data': body});
          return res;
        } else {
          return ApiResponse.fromJson(jsonDecode(apiResponse.body));
        }
      } else {
        ApiResponse response = ApiResponse(
          success: false,
          message: "Server error",
        );
        return response;
      }
    } catch (e) {
      ApiResponse response = ApiResponse(success: false, message: e.toString());
      return response;
    }
  }
}

class ApiResponse {
  bool success;
  String? message;
  dynamic data;

  ApiResponse({this.success = false, this.message, this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
    success: json.isNotEmpty,
    message: json.isNotEmpty ? 'success' : 'fail',
    data: json.isNotEmpty ? json['data'] : null,
  );
}
