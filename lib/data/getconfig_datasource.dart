import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:vpn/di/di.dart';

import 'package:vpn/utils/authmanager.dart';

class GetConfigDataSource {
  Future<String> getApiConfig() async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${AuthManager.readAccessToken()}'
    };
    try {
      final Dio dio = locator.get();
      var response = await dio.request(
        '/api/subscription/getConfigs',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );
      // print(response);
      if (response.statusCode == 200) {
        print(json.encode(response.data));
        return json.encode(response.data);
      } else {
        throw Exception('Unknown Error');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
