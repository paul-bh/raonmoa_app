import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  static bool useHighCapacityMode = false;
  static double graphViewIntervalSeconds = 15 * 60;

  static void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // set useHighCapacityMode to true if null
    if (prefs.getBool('useHighCapacityMode') == null) {
      prefs.setBool('useHighCapacityMode', false);
    }
    useHighCapacityMode = prefs.getBool('useHighCapacityMode')!;
    // set autoLogin to false if null
    if (prefs.getBool('autoLogin') == null) {
      prefs.setBool('autoLogin', false);
    }
  }
}
