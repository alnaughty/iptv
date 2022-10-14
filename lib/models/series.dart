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

  @override
  String toString() => "${toJson()}";

  Map<String, dynamic> toJson() => {
        "title": title,
        "entries": entries.map((e) => e.toJson()).toList(),
      };
}
