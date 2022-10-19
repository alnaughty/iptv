import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vtv/data_component/main_data.dart';
import 'package:vtv/models/m3u_categorized.dart';
import 'package:vtv/models/series.dart';
import "package:m3u_z_parser/src/models/m3u_entry.dart";
import 'package:vtv/services/lms_handler.dart';
import 'package:vtv/utils/extensions/string.dart';
import 'package:m3u_z_parser/extension/extension.dart';

class DatabaseHandler with LMSHelper {
  DatabaseHandler._pr();
  static final DatabaseHandler _instance = DatabaseHandler._pr();
  static DatabaseHandler get instance => _instance;
  static final MainData _mainData = MainData.instance;
  static Database? _database;
  Future<Database> get database async => _database ??= await _initDB();

  Future<Database> _initDB() async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String path = join(documentsDir.path, "vtv.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE categories(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)');
    await db.execute(
        'CREATE TABLE entries(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, url TEXT NOT NULL, duration INTEGER NULL, image TEXT NULL, category_id INT NOT NULL, type INT NOT NULL, FOREIGN KEY (category_id) REFERENCES categories (id))');
  }

  // Future<int> addValue({required List<M3UCategorized> data}) async {
  //   final Database db = await instance.database;
  //   await clearTableLocal(db);
  //   for (M3UCategorized category in data) {
  //     await db.insert("categories", {
  //       "name": category.group,
  //     }).then((int id) async {
  //       for (M3UEntry entry in category.entries) {
  //         await db.insert("entries", {
  //           "name": entry.name,
  //           "url": entry.url,
  //           "category_id": id,
  //         });
  //       }
  //     });
  //   }
  //   return 1;
  // }

  Future<void> clearTable() async {
    final Database db = await instance.database;
    await db.rawDelete("DELETE FROM categories");
    await db.rawDelete("DELETE FROM entries");
  }

  Future<void> clearTableLocal(Database db) async {
    await db.rawDelete("DELETE FROM categories");
    await db.rawDelete("DELETE FROM entries");
  }

  Future<int> updateCategoryType(int type) async {
    try {
      final Database db = await instance.database;
      return await db.update("categories", {
        "type": type,
      });
    } catch (e) {
      return -1;
    }
  }

  Future<int> addCategory(String name) async {
    try {
      final Database db = await instance.database;
      return await db.insert("categories", {
        "name": name,
      });
    } catch (e) {
      return -1;
    }
  }

  bool containsUrl(String url, String needle) =>
      url.contains(needle) || url.contains("${needle}s");
  int getType(String url) {
    final String finUrl = url.toLowerCase();
    if (containsUrl(finUrl, "movie")) {
      return 2;
    } else if (containsUrl(finUrl, "serie")) {
      return 3;
    } else if (containsUrl(finUrl, "live")) {
      return 1;
    }
    return 0;
  }

  Future<int> addEntry(int categoryID, M3uParsedEntry entry) async {
    try {
      final Database db = await instance.database;
      Map<String, dynamic> data = entry.toJson();
      data.addAll({
        "category_id": categoryID,
      });
      if (entry.url != null) {
        int type = getType(entry.url!);
        if (type == 0 || type == 1) {
          print("LIVE FOUND!");
        }
        data.addAll({
          "type": type,
        });
      } else {
        data.addAll({"type": 0});
      }
      return await db.insert(
        "entries",
        data,
      );
    } catch (e) {
      return -1;
    }
  }

  // Future<void> get joinedData async {
  //   final Database db = await instance.database;
  //   final List dat = await db.rawQuery("SELECT *  FROM categories");
  //   List<M3UCategorized> ff = [];
  //   for (Map<String, dynamic> datum in dat) {
  //     Map<String, dynamic> js = Map.from(datum);
  //     // js.addAll({"D": "ADSADS"});
  //     // print(js);
  //     final List e = await db.rawQuery(
  //         "SELECT *  FROM entries WHERE category_id = ${datum['id']}");
  //     List<M3uEntry> data = e
  //         .map(
  //           (e) => M3uEntry.fromEntryInformation(
  //             link: e['url'],
  //             information: EntryInfo(attributes: {
  //               "tvg-logo": e['image'],
  //               "group-title": datum['name'],
  //               "title-clean": e['name']
  //                   .toString()
  //                   .replaceAll(season, "")
  //                   .replaceAll(episode, "")
  //                   .replaceAll(epAndSe, "")
  //                   .trim(),
  //             }, duration: e['duration'], title: e['name']),
  //           ),
  //         )
  //         .toList();
  // List<Map<String, List<M3uEntry>>> _dd = categorizeByTitle(data);
  // Map<String, List<M3uEntry>> seriesCategorized = _dd[0];
  // Map<String, List<M3uEntry>> moviesCategorized = _dd[1];
  // Map<String, List<M3uEntry>> liveCategorized = _dd[2];
  //     final List<Series> finalSeries = seriesCategorized.entries
  // .map((e) => Series(
  //     title: e.key,
  //     entries: e.value
  //         .map((e) => M3uParsedEntry.fromJson(e.toJson()))
  //         .toList()))
  //         .toList();
  //     final List<Series> finalMovies = moviesCategorized.entries
  //         .map((e) => Series(
  //             title: e.key,
  //             entries: e.value
  //                 .map((e) => M3uParsedEntry.fromJson(e.toJson()))
  //                 .toList()))
  //         .toList();
  //     final List<Series> finalLives = liveCategorized.entries
  //         .map((e) => Series(
  //             title: e.key,
  //             entries: e.value
  //                 .map((e) => M3uParsedEntry.fromJson(e.toJson()))
  //                 .toList()))
  //         .toList();
  // ff.add(
  //   M3UCategorized.withData(
  //     title: datum['name'],
  //     series: finalSeries.isNotEmpty ? finalSeries : [],
  //     movies: finalMovies.isNotEmpty ? finalMovies : [],
  //     lives: finalLives.isNotEmpty ? finalLives : [],
  //   ),
  // );
  //   }
  //   _mainData.populateAll(ff);
  //   return;
  // }

  Future<void> categorizeData() async {
    final Database db = await instance.database;
    final List data = await db.rawQuery("SELECT *  FROM categories");
    final List<M3UCategorized> ff = [];
    for (Map<String, dynamic> datum in data) {
      final List e = await db.rawQuery(
          "SELECT *  FROM entries WHERE category_id = ${datum['id']}");
      List<M3uEntry> _data = e
          .map(
            (e) => M3uEntry.fromEntryInformation(
              link: e['url'],
              information: EntryInfo(
                attributes: {
                  "tvg-logo": e['image'],
                  "group-title": datum['name'],
                  "title-clean": e['name']
                      .toString()
                      .replaceAll(season, "")
                      .replaceAll(episode, "")
                      .replaceAll(epAndSe, "")
                      .trim(),
                },
                duration: e['duration'],
                title: e['name'],
              ),
              type: e['type'] ?? 0,
            ),
          )
          .toList();
      List<Map<String, List<M3uEntry>>> _dd = categorizeBy(_data);
      final List<Series> moviesCategorized = _dd[1]
          .entries
          .map((e) => Series(
              title: e.key,
              entries: e.value
                  .map((e) => M3uParsedEntry.fromJson(e.toJson()))
                  .toList()))
          .toList();

      final List<Series> seriesCategorized = _dd[0]
          .entries
          .map((e) => Series(
              title: e.key,
              entries: e.value
                  .map((e) => M3uParsedEntry.fromJson(e.toJson()))
                  .toList()))
          .toList();
      // final List<M3uParsedEntry> liveCategorized = _dd[2]
      //     .entries
      //     .map((e) => M3uParsedEntry.fromJson(e.toJson()))
      //     .toList();
      ff.add(
        M3UCategorized.withData(
          title: datum['name'],
          series: seriesCategorized,
          movies: moviesCategorized,
          lives: _data.where((element) => element.type.toInt() <= 1).toList(),
        ),
      );
    }
    print("NOT EMPTY LIVE: ${ff.where((element) => element.lives.isNotEmpty)}");
    _mainData.populateAll(ff);
    return;
  }
}
