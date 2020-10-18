import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  final SharedPreferences shared;

  Preferences(this.shared);

  set uid(String value) => shared.setString("uid", value);
  String get uid => shared.getString("uid"); 

  static Future<Preferences> instance() => SharedPreferences.getInstance().then((value) => Preferences(value));
}
