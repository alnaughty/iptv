// ignore_for_file: non_constant_identifier_names

// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvData {
  EnvData._();
  static final EnvData _instance = EnvData._();
  static Future<EnvData> get instance async {
    await dotenv.load(fileName: ".env");
    return _instance;
  }

  String get imdb_api => dotenv.get('API_URL');
  String get imdb_key => dotenv.get('API_KEY');
  String get imdb_host => dotenv.get('API_HOST');
}
