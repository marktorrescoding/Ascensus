import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:openbeta/models/climbing_route.dart';

class LocalDatabase {
  static final _databaseName = "ClimbingDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'climbs';

  static final columnId = '_id';
  static final columnName = 'name';
  static final columnYds = 'yds';
  static final columnDescription = 'description';
  static final columnLocation = 'location';
  static final columnProtection = 'protection';

  // make this a singleton class
  LocalDatabase._privateConstructor();
  static final LocalDatabase instance = LocalDatabase._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnYds INTEGER NOT NULL,
            $columnDescription TEXT NOT NULL,
            $columnLocation TEXT NOT NULL,
            $columnProtection TEXT NOT NULL
          )
          ''');
  }

  // Helper methods

  Future<int> insert(ClimbingRoute route) async {
    Database db = await instance.database;
    return await db.insert(table, route.toJson());
  }

  Future<List<ClimbingRoute>> queryAllRoutes() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table);

    return List.generate(maps.length, (i) {
      return ClimbingRoute.fromJson(maps[i]);
    });
  }

  Future<List<ClimbingRoute>> searchRoutes(String name) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      where: '$columnName LIKE ?',
      whereArgs: ['%$name%'],
    );

    return List.generate(maps.length, (i) {
      return ClimbingRoute.fromJson(maps[i]);
    });
  }
}
