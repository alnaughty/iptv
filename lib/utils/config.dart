import 'dart:io';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vtv/utils/keys.dart';
import 'package:vtv/views/auth/auth.dart';
import 'package:vtv/views/auth/connect_via_credentials/connect_via_credentials.dart';
import 'package:vtv/views/auth/connect_via_m3u/connect_via_m3u.dart';
import 'package:vtv/views/auth/connect_via_mac_address/connect_via_mac.dart';
import 'package:vtv/views/landing_page.dart';

class AppConfig {
  AppConfig._singleton();
  static final AppConfig _instance = AppConfig._singleton();
  static AppConfig get instance => _instance;
  static final AppKeys _keys = AppKeys.instance;
  Route<dynamic>? Function(RouteSettings)? routes = (RouteSettings settings) {
    switch (settings.name) {
      case "/landing_page":
        return PageTransition(
          child: const LandingPage(),
          type: PageTransitionType.scale,
          curve: Curves.bounceOut,
          alignment: Alignment.center,
          isIos: Platform.isIOS || Platform.isMacOS,
          duration: const Duration(
            milliseconds: 500,
          ),
          reverseDuration: const Duration(
            milliseconds: 500,
          ),
        );
      case "/auth_page":
        return PageTransition(
          child: const AuthPage(),
          type: PageTransitionType.scale,
          curve: Curves.easeInOut,
          alignment: Alignment.center,
          isIos: Platform.isIOS || Platform.isMacOS,
          duration: const Duration(
            milliseconds: 500,
          ),
          reverseDuration: const Duration(
            milliseconds: 500,
          ),
        );
      case "/connect_via_m3u":
        return PageTransition(
          child: const ConnectViaM3U(),
          type: PageTransitionType.leftToRight,
          curve: Curves.easeInOut,
          alignment: Alignment.center,
          isIos: Platform.isIOS || Platform.isMacOS,
          duration: const Duration(
            milliseconds: 500,
          ),
          reverseDuration: const Duration(
            milliseconds: 500,
          ),
        );
      case "/connect_via_credentials":
        return PageTransition(
          child: const ConnectViaCredentials(),
          type: PageTransitionType.leftToRight,
          curve: Curves.easeInOut,
          alignment: Alignment.center,
          isIos: Platform.isIOS || Platform.isMacOS,
          duration: const Duration(
            milliseconds: 500,
          ),
          reverseDuration: const Duration(
            milliseconds: 500,
          ),
        );
      case "/connect_via_mac":
        return PageTransition(
          child: const ConnectViaMac(),
          type: PageTransitionType.leftToRight,
          curve: Curves.easeInOut,
          alignment: Alignment.center,
          isIos: Platform.isIOS || Platform.isMacOS,
          duration: const Duration(
            milliseconds: 500,
          ),
          reverseDuration: const Duration(
            milliseconds: 500,
          ),
        );
      case "/favorite_page":
        return PageTransition(
          child: Container(),
          type: PageTransitionType.scale,
          curve: Curves.easeInOut,
          alignment: Alignment.center,
          isIos: Platform.isIOS || Platform.isMacOS,
          duration: const Duration(
            milliseconds: 500,
          ),
          reverseDuration: const Duration(
            milliseconds: 500,
          ),
        );
      case "/connect_m3u":
        return PageTransition(
          child: Container(),
          type: PageTransitionType.rightToLeft,
          duration: const Duration(
            milliseconds: 500,
          ),
          reverseDuration: const Duration(
            milliseconds: 500,
          ),
        );
      case "/connect_credentials":
        return PageTransition(
          child: Container(),
          type: PageTransitionType.rightToLeft,
          duration: const Duration(
            milliseconds: 500,
          ),
          reverseDuration: const Duration(
            milliseconds: 500,
          ),
        );
      case "/connect_mac":
        return PageTransition(
          child: Container(),
          type: PageTransitionType.rightToLeft,
          duration: const Duration(
            milliseconds: 500,
          ),
          reverseDuration: const Duration(
            milliseconds: 500,
          ),
        );
      default:
        return PageTransition(
          child: const LandingPage(),
          type: PageTransitionType.scale,
          isIos: Platform.isIOS || Platform.isMacOS,
          alignment: Alignment.center,
          duration: const Duration(
            milliseconds: 500,
          ),
          reverseDuration: const Duration(
            milliseconds: 500,
          ),
        );
    }
  };
}
