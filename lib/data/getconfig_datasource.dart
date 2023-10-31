import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:vpn/di/di.dart';
import 'package:vpn/models/apiconfigsmode.dart';

import 'package:vpn/utils/authmanager.dart';

class GetConfigDataSource {
  Future<ApiConfigs> getApiConfig() async {
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

      if (response.statusCode == 200) {
        ApiConfigs resault = configsFromJson(json.encode(response.data));
        return resault;
      } else {
        throw Exception('Unknown Error');
      }
    } catch (e) {
      rethrow;
    }
  }
}
