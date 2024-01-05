import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:vpn/utils/authmanager.dart';
import '../di/di.dart';

class ProfileDataSource {
  Future<String> getProfileData() async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${AuthManager.readAccessToken()}'
    };
    try {
      final Dio dio = locator.get();
      var response = await dio.request(
        '/api/profile',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );
      // print(response);
      if (response.statusCode == 200) {
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
