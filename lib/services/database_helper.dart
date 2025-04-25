import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'rota_erzincan.db');
    return await openDatabase(
      path,
      version: 3, // versiyon yükseltildi 🔺
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // upgrade fonksiyonu eklendi
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE routes (
        id TEXT PRIMARY KEY,
        title TEXT,
        subtitle TEXT, -- ✅ burada olmalı
        imageUrl TEXT,
        icon TEXT,
        distanceKm REAL,
        durationMinutes INTEGER,
        isUserAdded INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE route_stops (
        id TEXT PRIMARY KEY,
        routeId TEXT,
        latitude REAL,
        longitude REAL,
        title TEXT,
        description TEXT, -- 🔺 eklendi
        stopOrder INTEGER DEFAULT 0, -- ✅ EKLE BUNU
        FOREIGN KEY(routeId) REFERENCES routes(id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE route_stops ADD COLUMN description TEXT');
    }
    if (oldVersion < 3) {
      await db.execute(
          'ALTER TABLE route_stops ADD COLUMN stopOrder INTEGER DEFAULT 0'); // ✅ EKLENDİ
    }
  }

  Future<List<Map<String, dynamic>>> getAllRoutes() async {
    final db = await database;
    return await db.query('routes');
  }

  Future<List<Map<String, dynamic>>> getStopsForRoute(String routeId) async {
    final db = await database;
    return await db.query(
      'route_stops',
      where: 'routeId = ?',
      whereArgs: [routeId],
    );
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('route_stops');
    await db.delete('routes');
  }
}
