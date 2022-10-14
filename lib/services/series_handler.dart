// import 'package:m3u_z_parser/extension/extension.dart';
// import 'package:m3u_z_parser/mixin/mixin.dart';
// import 'package:m3u_z_parser/src/models/m3u_entry.dart';
import "package:m3u_z_parser/src/models/m3u_entry.dart";

class SeriesHelper {
  // final RegExp finalRegex = RegExp(
  //     "((season|SEASON|Season)( \\d+|\\d+))|((episode|EPISODE|Episode)((\\d+)|(( \\d+))))|(\\b(s|S)(\\d+))|((((e|E)(\\d+))|((ep|Ep|EP|eP))(\\d+)))");
  final RegExp season = RegExp(
    r"((\b(s|S))(\d+))|((\b(season|SEASON|Season))((\d+)|( \d+)))",
    multiLine: true,
  );

  final RegExp episode = RegExp(
      r"((\b(e|E))(\d+))|((\b(episode|EPISODE|Episode|ep|EP|Ep))((\d+)|( \d+)))");
  final epAndSe = RegExp(
      r"\b(s|S|SEASON|season|Season)(\d+(E|e|EPISODE|episode|Episode(\d+)))");
  bool hasMatchedAll(String text) =>
      season.hasMatch(text) || episode.hasMatch(text) || epAndSe.hasMatch(text);
  Map<String, List<M3uEntry>> categorizeByTitle(List<M3uEntry> data) {
    return data.fold(<String, List<M3uEntry>>{}, (old, current) {
      final prp = current.attributes['title-clean'] ?? "tvg-id";
      if (hasMatchedAll(current.title)) {
        if (!old.containsKey(prp)) {
          old[prp] = [current];
        } else {
          old[prp]!.add(current);
        }
      }
      return old;
    });
  }
  // List<M3uEntry> ff = <M3uEntry>[];
  // void ffe() {
  //   ff
  //       .map(
  //         (e) => e.title
  //             .replaceAll(RegExp(".*S?(\\d+)"), "")
  //             .replaceAll(RegExp(".*E?(\\d+)"), "")
  //             .replaceAll(RegExp(".*EPISODE?(\\d+)"), "")
  //             .replaceAll(RegExp(".*SEASON?(\\d+)"), "")
  //             .replaceAll(RegExp(".*episode?(\\d+)"), "")
  //             .replaceAll(RegExp(".*season?(\\d+)"), "")
  //             .replaceAll("", "replace"),
  //       )
  //       .toList();
  // }
}
