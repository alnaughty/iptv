import 'dart:convert';

extension FF on String {
  bool get isEmail {
    final RegExp emailRegExp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    );
    return emailRegExp.hasMatch(this);
  }

  bool get isValidUrl {
    final RegExp exp =
        RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
    return exp.hasMatch(this);
  }
}

extension SeriesCheck on String {
  static final RegExp f = RegExp(
    r'S(\d\d?)',
  );
  static final RegExp s = RegExp(r'E(\d\d?)');

  bool get isSeriesName {
    return contains(f) || contains(s);
  }
}

extension CONVERTER on String {
  String createMd5() {
    String toHash = this;
    var bytesToHash = utf8.encode(toHash);
    // var md5Digest = md5.convert(bytesToHash);
    // print(md5Digest.toString());
    // return "$md5Digest";
    return "";
  }
}
