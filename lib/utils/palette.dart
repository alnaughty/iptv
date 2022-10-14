import 'package:flutter/material.dart';

class Palette {
  final Color dark = const Color.fromRGBO(0, 61, 69, 0.9);
  final Color appmaincolor = const Color.fromRGBO(50, 109, 117, 0.9);
  final Color lightbluecolor = const Color.fromRGBO(1, 197, 223, 0.9);
  final Color transparentwhitecolor = const Color.fromRGBO(126, 141, 145, 0.9);
  final LinearGradient background = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        Color.fromRGBO(1, 16, 17, 0.9),
        Color.fromRGBO(0, 61, 69, 0.9),
        Color.fromRGBO(0, 171, 194, 0.9)
      ]);

  final LinearGradient blacktopbackground = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        Color.fromRGBO(1, 1, 1, 0.9),
        Color.fromRGBO(1, 16, 17, 0.9),
        Color.fromRGBO(0, 61, 69, 0.9),
        Color.fromRGBO(0, 171, 194, 0.9)
      ]);

  final LinearGradient pinkbackground = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        Color.fromRGBO(1, 1, 1, 0.9),
        Color.fromRGBO(1, 16, 17, 0.9),
        Color.fromRGBO(0, 61, 69, 0.9),
        Color.fromRGBO(0, 171, 194, 0.9)
      ]);
}
