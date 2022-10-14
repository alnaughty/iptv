import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vtv/models/m3u_categorized.dart';
import 'package:vtv/models/series.dart';
import "package:m3u_z_parser/src/models/m3u_entry.dart";
import 'package:vtv/services/series_handler.dart';
import 'package:vtv/utils/extensions/string.dart';
import 'package:m3u_z_parser/extension/extension.dart';

class DatabaseHandler with SeriesHelper {
  DatabaseHandler._pr();
  static final DatabaseHandler _instance = DatabaseHandler._pr();
  static DatabaseHandler get instance => _instance;

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDB();

  Future<Database> _initDB() async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String path = join(documentsDir.path, "mydata.db");

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
        'CREATE TABLE entries(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, url TEXT NOT NULL, duration INTEGER NULL, image TEXT NULL, category_id INT NOT NULL, FOREIGN KEY (category_id) REFERENCES categories (id))');
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

  Future<int> addEntry(int categoryID, M3uParsedEntry entry) async {
    try {
      final Database db = await instance.database;
      Map<String, dynamic> data = entry.toJson();
      data.addAll({
        "category_id": categoryID,
      });
      return await db.insert(
        "entries",
        data,
      );
    } catch (e) {
      return -1;
    }
  }

  Future<List<M3UCategorized>> get joinedData async {
    final Database db = await instance.database;
    final List dat = await db.rawQuery("SELECT *  FROM categories");
    List<M3UCategorized> ff = [];
    for (Map<String, dynamic> datum in dat) {
      Map<String, dynamic> js = Map.from(datum);
      // js.addAll({"D": "ADSADS"});
      // print(js);
      final List e = await db.rawQuery(
          "SELECT *  FROM entries WHERE category_id = ${datum['id']}");
      List<M3uEntry> series = e
          .map(
            (e) => M3uEntry.fromEntryInformation(
              link: e['url'],
              information: EntryInfo(attributes: {
                "tvg-logo": e['image'],
                "group-title": datum['name'],
                "title-clean": e['name']
                    .toString()
                    .replaceAll(season, "")
                    .replaceAll(episode, "")
                    .replaceAll(epAndSe, "")
                    .trim(),
              }, duration: e['duration'], title: e['name']),
            ),
          )
          .toList();
      Map<String, List<M3uEntry>> seriesCategorized = categorizeByTitle(series);
      // seriesCategorized.map((key, value) => e);
      final List<Series> finalSeries = seriesCategorized.entries
          .map((e) => Series(
              title: e.key,
              entries: e.value
                  .map((e) => M3uParsedEntry.fromJson(e.toJson()))
                  .toList()))
          .toList();
      print("SERIES : $finalSeries");

      ff.add(
        M3UCategorized.withData(
          title: datum['name'],
          series: finalSeries.isNotEmpty ? finalSeries : [],
        ),
      );
    }
    return ff;
  }
}
