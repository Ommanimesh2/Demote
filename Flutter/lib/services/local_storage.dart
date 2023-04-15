import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage{

  static late LocalStorage _instance;
  static late SharedPreferences _prefs;

  static Future<void> getInstance() async {
    _instance = LocalStorage();
    _prefs = await SharedPreferences.getInstance();
  }


  Future setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  Future setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  Future setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  Future setDouble(String key, double value) async {
    await _prefs.setDouble(key, value);
  }

  Future setStringList(String key, List<String> value) async {
    await _prefs.setStringList(key, value);
  }

  String getString(String key) {
    return _prefs.getString(key)?? '';
  }

  int getInt(String key) {
    return _prefs.getInt(key) ?? 0;
  }

  bool getBool(String key) {
    return _prefs.getBool(key) ?? false;
  }

  double getDouble(String key) {
    return _prefs.getDouble(key) ?? 0.0;
  }

  List<String> getStringList(String key) {
    return _prefs.getStringList(key) ?? [];
  }
}



const String kUserName = 'userName';
const String kUserEmail = 'userEmail';
const String kIsLoggedIn = 'isLoggedIn';
const String kUniqueId = 'uniqueId';
const String kactiveDevice = 'activeDevice';

void setUserName(String userName) {
  LocalStorage().setString(kUserName, userName);
}

String? getUserName() {
  return LocalStorage().getString(kUserName);
}

void setUserEmail(String userEmail) {
  LocalStorage().setString(kUserEmail, userEmail);
}

String? getUserEmail() {
  return LocalStorage().getString(kUserEmail);
}

void setIsLoggedIn(bool isLoggedIn) {
  LocalStorage().setBool(kIsLoggedIn, isLoggedIn);
}

bool getIsLoggedIn() {
  return LocalStorage().getBool(kIsLoggedIn);
}

void setUniqueId(String uniqueId) {
  LocalStorage().setString(kUniqueId, uniqueId);
}

String? getUniqueId() {
  return LocalStorage().getString(kUniqueId);
}

void setActiveDevice(String activeDevice) {
  LocalStorage().setString(kactiveDevice, activeDevice);
}

String? getActiveDevice() {
  return LocalStorage().getString(kactiveDevice);
}


