import 'package:path/path.dart';
import 'package:vtv/models/m3u_categorized.dart';

class Series {
  final String title;
  final List<M3uParsedEntry> entries;
  const Series({
    required this.title,
    required this.entries,
  });

  factory Series.fromJson(Map<String, dynamic> json) {
    List data = json['data'] ?? [];
    return Series(
      title: json['title'] ?? "",
      entries: data.map((e) => M3uParsedEntry.fromJson(e)).toList(),
    );
  }
  factory Series.fromJson2(Map<String, dynamic> json) {
    List data = json['entries'] ?? [];
    return Series(
      title: json['title'] ?? "",
      entries: data
          .map((e) => M3uParsedEntry.embeded(
              e['url'], e['name'], e['image'], e['duration']))
          .toList(),
    );
  }

  @override
  String toString() => "${toJson()}";

  Map<String, dynamic> toJson() => {
        "title": title,
        "entries": entries.map((e) => e.toJson()).toList(),
      };
}
