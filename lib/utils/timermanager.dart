import 'package:vpn/di/di.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerManager {
  static final SharedPreferences _prefs = locator.get();
  static saveTimer(DateTime datetime) async {
    await _prefs.setStringList('datetime', [
      datetime.year.toString(),
      datetime.month.toString(),
      datetime.day.toString(),
      datetime.hour.toString(),
      datetime.minute.toString(),
      datetime.second.toString()
    ]);
    print('save shod : $datetime');
  }

  static List<String>? readTimer() {
    return _prefs.getStringList('datetime');
  }

  static cleartimer() {
    return _prefs.remove('datetime');
  }
}
