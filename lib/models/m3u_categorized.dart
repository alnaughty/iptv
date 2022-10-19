import 'package:vtv/models/series.dart';
import "package:m3u_z_parser/src/models/m3u_entry.dart";

class M3UCategorized {
  final String group;
  final List<Series> series;
  final List<M3uEntry> lives;
  final List<Series> movies;
  // List<M3uParsedEntry> entries;
  // M3UType type;

  M3UCategorized({
    required this.group,
    required this.lives,
    required this.movies,
    required this.series,
    // required this.entries,
    // required this.type,
  });
  static M3UType fromInt(int i) {
    switch (i) {
      case 0:
        return M3UType.NONE;
      case 1:
        return M3UType.LIVE;

      case 2:
        return M3UType.MOVIE;
      case 3:
        return M3UType.SERIES;
      default:
        return M3UType.NONE;
    }
  }

  factory M3UCategorized.withData({
    required String title,
    required List<Series> series,
    required List<Series> movies,
    required List<M3uEntry> lives,
  }) =>
      M3UCategorized(
        series: series,
        movies: movies,
        lives: lives,
        group: title,
      );
  factory M3UCategorized.fromJson(
      Map<String, dynamic> json, List<M3uEntry> live) {
    final List series = json['series'] ?? [];
    final List movies = json['movies'] ?? [];
    return M3UCategorized(
      group: json['name'],
      lives: live,
      movies: movies.map((e) => Series.fromJson(e)).toList(),
      series: series.map((e) => Series.fromJson(e)).toList(),
    );
  }
  @override
  String toString() => "${toJson()}";

  Map<String, dynamic> toJson() => {
        "name": group,
        "series": series,
        "movies": movies,
        "lives": lives,
        // "type": type.toInt(),
      };
}

class M3uParsedEntry {
  final String? image;
  final String name;
  final String? url;
  final int? duration;
  M3uParsedEntry({
    required this.image,
    required this.name,
    required this.url,
    required this.duration,
  });
  Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
        "duration": duration,
        "image": image,
      };
  factory M3uParsedEntry.fromJson(Map<String, dynamic> json) {
    return M3uParsedEntry(
      image: json['attributes'] == null ? null : json['attributes']['tvg-logo'],
      name: json['title'],
      url: json['link'],
      duration: json['duration'],
    );
  }
  factory M3uParsedEntry.embeded(
          String url, String name, String? image, int? duration) =>
      M3uParsedEntry(
        duration: duration,
        // controller: controller,
        name: name,
        image: image,
        url: url,
      );
  factory M3uParsedEntry.converted(String url, String name, String? image) {
    return M3uParsedEntry(
      // controller: null,
      duration: null,
      name: name,
      image: image,
      url: url,
    );
  }
  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }
}

// ignore_for_file: constant_identifier_names
enum M3UType { SERIES, MOVIE, LIVE, NONE }

extension HandleType on M3UType {
  int toInt() {
    M3UType type = this;
    if (type == M3UType.NONE) {
      return 0;
    } else if (type == M3UType.LIVE) {
      return 1;
    } else if (type == M3UType.MOVIE) {
      return 2;
    } else {
      return 3;
    }
  }
}
