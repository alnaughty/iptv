import 'package:flutter/material.dart';

class AuthAssets {
  // List<Widget> contents = [];
  final List buttons = [
    "connexion via m3u".toUpperCase(),
    "connexion via les informations d'identification".toUpperCase(),
    "CONNEXION VIA ADRESSE MAC",
  ];

  final List<String> pages = [
    "/connect_via_m3u",
    "/connect_via_credentials",
    "/connect_via_mac",
  ];

  late final List<FocusNode> nodes = buttons
      .map((e) => FocusNode(
            debugLabel: e,
          ))
      .toList();

  int? currentFocus;
}
