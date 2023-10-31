import 'package:vpn/di/di.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  static final SharedPreferences _prefs = locator.get();
  //Is Connect
  static saveConnect(bool isConnect) async {
    await _prefs.setBool('isConnect', isConnect);
    print('save shod : $isConnect');
  }

  static bool? readConnect() {
    return _prefs.getBool('isConnect');
  }


  //Access Token
  static saveAccessToken(String accessToken) async {
    await _prefs.setString('accessToken', accessToken);
    print('save shod : $accessToken');
  }

  static String? readAccessToken() {
    return _prefs.getString('accessToken');
  }

  // //Refresh Token
  // static saveRefreshToken(String refreshToken) async {
  //   await _prefs.setString('refreshToken', refreshToken);
  //   print('save shod : $refreshToken');
  // }

  // static String? readRefreshToken() {
  //   return _prefs.getString('refreshToken');
  // }

  //Login Time
  static saveLoginTime(DateTime loginTime) async {
    await _prefs.setString('loginTime', loginTime.toString());
    print('save shod : $loginTime');
  }

  static String? readLoginTime() {
    return _prefs.getString('loginTime');
  }

  //Token Expirein
  static saveExpireIn(int expireIn) async {
    await _prefs.setInt('expireIn', expireIn);
    print('save shod : $expireIn');
  }

  static int? readExpireIn() {
    return _prefs.getInt('expireIn');
  }

  //Clear Auth Data
  static clearAuthData() async {
    await _prefs.clear();
    print('Authe Data Cleared');
  }

  static bool canLogin() {
    final String? accessToken = readAccessToken();
    final DateTime? loginTime =
        readLoginTime() != null ? DateTime.parse(readLoginTime()!) : null;
    final int? expireIn = readExpireIn();
    if (accessToken != null && loginTime != null && expireIn != null) {
      if (DateTime.now().difference(loginTime).inSeconds < expireIn) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
