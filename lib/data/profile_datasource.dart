import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:vpn/utils/authmanager.dart';
import '../di/di.dart';
import '../models/profilemodel.dart';

class ProfileDataSource {
  Future<ProfileData> getProfileData() async {
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

      if (response.statusCode == 200) {
        ProfileData resault = profileDataFromJson(json.encode(response.data));
        return resault;
      } else {
        throw Exception('Unknown Error');
      }
    } catch (e) {
      rethrow;
    }
  }
}
