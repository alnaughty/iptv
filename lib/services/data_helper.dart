import 'dart:io';

import 'package:flutter/services.dart';
import 'package:vtv/services/firebase_auth.dart';
import 'package:vtv/services/m3u_url_handler.dart';
import 'package:vtv/utils/global.dart';

mixin DataHelper implements M3UHandler, FirebaseAuthServices {
  Future<void> downloadAndConvert(String url, String playlist,
      {required ValueChanged<int> percentCallback,
      required ValueChanged<bool> callback,
      ValueChanged<String>? textCallback}) async {
    return await downloadFromUrl(url, progressPercentage: (p) {
      // setState(() {
      //   percent = (100 * p).toInt();
      // });
      percentCallback((100 * p).toInt());
      // print("PERCENT : $percent");
      // if (percent == 100) {
      //   setState(() {
      //     _isLoading = false;
      //     percent = null;
      //   });
      // }
    }).then((v) async {
      if (v != null) {
        await cacher.setPlaylist(
          playlist,
        );
        if (textCallback != null) {
          textCallback("Conversion de données");
        }
        await categorizeParse(File(v));
        callback(true);
      } else {
        callback(false);
      }
      return;
    });
  }
}
