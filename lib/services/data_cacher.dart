import 'package:shared_preferences/shared_preferences.dart';

class DataCacher {
  DataCacher._pr();
  static final DataCacher _instance = DataCacher._pr();
  static DataCacher get instance => _instance;
  late final SharedPreferences _prefs;
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setUID(String id) async => await _prefs.setString("uid", id);
  String? get uid => _prefs.getString("uid");
  Future<void> removeUID() async => await _prefs.remove('uid');
  String? get playlistName => _prefs.getString("playlistName");
  Future<void> setPlaylist(String f) async =>
      await _prefs.setString("playlistName", f);
}
