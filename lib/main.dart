import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:vtv/core/vtv_app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vtv/models/env_data.dart';
import 'package:vtv/utils/global.dart';

late EnvData envData;
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();
  await cacher.initialize();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await dotenv.load();
  envData = await EnvData.instance;
  runApp(
    VTVApp(),
  );
  FlutterNativeSplash.remove();
}
