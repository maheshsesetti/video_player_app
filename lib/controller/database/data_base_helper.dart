import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:video_player_app/model/video_model.dart';

class DatabaseHelper {
  Database? _database;
  final tableName = 'videos';
  List<dynamic> wholeDataList = [];

  Future get database async {
    if (_database != null) return _database;
    _database = await _initializedDB('dummy.db');
    return _database;
  }

  Future _initializedDB(String filePath) async {
    var directory = await getApplicationDocumentsDirectory();
    var path = '${directory.path}/$filePath';
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableName(id INTEGER PRIMARY KEY,
      DummyData JSON NOT NULL
      )
    ''');
  }

  Future addDataLocally({wholedata}) async {
    final db = await database;
    await db.insert(tableName, {"DummyData": wholedata});
    
    return 'added';
  }

  Future<List<VideoModel>> readAllData() async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db!.query(tableName);
    var res = json.decode(maps[0]['DummyData']);
    return List.generate(res[0].length, (index) {
      return VideoModel(
        videoId: res[0][index]["video_id"],
        videoFk: res[0][index]["video_fk"],
        views: res[0][index]["views"],
        videourl: res[0][index]["videourl"],
        rendering: res[0][index]["rendering"],
        thumbnail: res[0][index]["thumbnail"],
        lastupdate: res[0][index]["lastupdate"],
        videoLocalTitle: res[0][index]["video_local_title"],
        videoTitle: res[0][index]["video_title"],
      );
    });
  }
}
