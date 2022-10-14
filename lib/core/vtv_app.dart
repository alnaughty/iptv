import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vtv/utils/config.dart';
import 'package:vtv/utils/keys.dart';
import 'package:vtv/utils/palette.dart';
import 'package:vtv/views/landing_page.dart';

class VTVApp extends StatelessWidget with Palette {
  VTVApp({Key? key}) : super(key: key);
  static final AppConfig _config = AppConfig.instance;
  static final AppKeys _keys = AppKeys.instance;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VTV Online',
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: appmaincolor,
        fontFamily: "Default",
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(.3),
            fontFamily: "Default",
          ),
          labelStyle: const TextStyle(
            color: Colors.white,
            fontFamily: "Default",
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24.5,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Colors.white,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Colors.white,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Colors.white,
              width: 2,
            ),
          ),
        ),
      ),
      initialRoute: '/landing_page',
      home: const LandingPage(),
      onGenerateRoute: _config.routes,
    );
  }
}
