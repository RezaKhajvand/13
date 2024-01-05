import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:vpn/models/gettokenmodel.dart';
import '../di/di.dart';

class LoginDataSource {
  Future<GetToken> getLogin(String username, String password) async {
    //
    final Dio dio = locator.get();
    //
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var data = {
      'grant_type': 'password',
      'client_id': '1',
      'client_secret': 'ZdCELRPrfNqXLrrPHU0r90SKQUg9qjdGywbVPUlB',
      'username': username,
      'password': password,
      'scope': ''
    };

    try {
      var response = await dio
          .request(
            '/oauth/token',
            options: Options(
              method: 'POST',
              headers: headers,
            ),
            data: data,
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        GetToken resault = getTokenFromJson(json.encode(response.data));
        return resault;
      } else {
        throw Exception('Unknown Error');
      }
    } catch (e) {
      rethrow;
    }
  }
}
