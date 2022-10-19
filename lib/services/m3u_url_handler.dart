import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:m3u_z_parser/m3u_z_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:vtv/models/m3u_categorized.dart';
import 'package:vtv/services/data_handler.dart';
import "package:m3u_z_parser/src/models/m3u_entry.dart";

class M3UHandler {
  // late Future<Directory?> _applicationSupportDirectory;
  static final Dio _dio = Dio();
  // static final AuthLoadingState _state = AuthLoadingState.instance;
  // M3UHandler() {
  //   // _applicationSupportDirectory = getApplicationSupportDirectory();
  // }
  static final DatabaseHandler _dbHandler = DatabaseHandler.instance;

  Future<String?> get savePath async {
    Directory? dir = await getApplicationSupportDirectory();
    return dir.path;
  }

  Future<String?> moveToFile(File file) async {
    try {
      String fileContent = await file.readAsString().catchError((e) {
        print("ERROR READING DATA : $e");
      });
      String? path = await savePath;
      if (path == null) return null;
      final Directory downloadDir = await Directory("$path/M3U").create();
      if (!(await downloadDir.exists())) return null;
      // await file.delete();
      File ff = File("${downloadDir.path}/data.m3u");
      await ff.writeAsString(fileContent);
      return ff.path;
    } catch (e) {
      print("ERROR FILE MOVE $e");
      return null;
    }
  }

  Future<String?> downloadFromUrl(String url,
      {ValueChanged<double>? progressPercentage}) async {
    try {
      String? path = await savePath;
      if (path == null) return null;
      final Directory downloadDir = await Directory("$path/M3U").create();
      if (!(await downloadDir.exists())) return null;
      // final String title = url.createMd5();
      return await _dio
          .downloadUri(
        Uri.parse(url),
        "${downloadDir.path}/data.m3u",
        onReceiveProgress: progressPercentage != null
            ? (int sent, int total) {
                progressPercentage(sent / total);
              }
            : null,
      )
          .then((response) {
        if (response.statusCode == 200) {
          File ff = File("${downloadDir.path}/data.m3u");
          print(ff.path);
          return ff.path;
        }
        return null;
      });
    } on HttpException catch (e) {
      print("HTTP ERROR : $e");
      return null;
    } on DioError catch (e) {
      print("ERROR : $e");
      Fluttertoast.showToast(msg: "Erreur lors du téléchargement des données.");
      return null;
    } on SocketException catch (e) {
      print("NO INTERNET! : $e");
      return null;
    }
  }

  extractM3uData(File m3u) async {
    m3u.readAsString();
  }

  static final FilePicker _picker = FilePicker.platform;
  Future<File?> browseM3U({String title = "mon_playlist_"}) async {
    // FilePicker().pickFiles();
    return await _picker.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      withData: true,
      allowedExtensions: [
        'm3u',
      ],
    ).then((FilePickerResult? value) async {
      if (value != null) {
        PlatformFile file = value.files.first;
        final File ff = File(file.path!);
        return ff;
      }
      return null;
    });
  }

  Future<List<M3uEntry>?> m3uToFile(File file) async {
    try {
      final List<M3uEntry> _entries =
          await M3uZParser.parse(await file.readAsString());
      return _entries;
    } catch (e) {
      print("ERROR : $e");
      return null;
    }
  }

  Future<void> categorizeParse(File file) async {
    try {
      await _dbHandler.clearTable();
      // ignore: no_leading_underscores_for_local_identifiers
      final List<M3uEntry> _entries =
          await M3uZParser.parse(await file.readAsString());
      print("CATEGORIZE!");
      Map<String, List<M3uEntry>> _cats =
          _entries.categorize(needle: "group-title");
      for (MapEntry entry in _cats.entries) {
        int catId = await _dbHandler.addCategory(entry.key);
        final List<M3uEntry> _genEnts = entry.value as List<M3uEntry>;
        for (M3uEntry entry in _genEnts) {
          // print("DURATION ${entry.duration}");
          // print("ENTRY : ${entry.title}");
          await _dbHandler.addEntry(
            catId,
            M3uParsedEntry.fromJson(
              entry.toJson(),
            ),
          );
        }
      }
      await _dbHandler.categorizeData();
      print("CATEGORIZED!");
      return;
    } catch (e) {
      print("ERROR SA CONVERT: $e");
      return;
    }
  }
}
