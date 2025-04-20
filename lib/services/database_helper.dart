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
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE routes (
        id TEXT PRIMARY KEY,
        title TEXT,
        subtitle TEXT,
        imageUrl TEXT,
        icon INTEGER,
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
        FOREIGN KEY(routeId) REFERENCES routes(id) ON DELETE CASCADE
      )
    ''');
  }

  // İsteğe bağlı: Tüm route'ları çekme
  Future<List<Map<String, dynamic>>> getAllRoutes() async {
    final db = await database;
    return await db.query('routes');
  }

  // İsteğe bağlı: Bir route'ın duraklarını çekme
  Future<List<Map<String, dynamic>>> getStopsForRoute(String routeId) async {
    final db = await database;
    return await db.query('route_stops', where: 'routeId = ?', whereArgs: [routeId]);
  }

  // Tüm veritabanını sil (debug için faydalı)
  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('route_stops');
    await db.delete('routes');
  }
}
