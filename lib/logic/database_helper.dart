import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'dart:async';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  final _changeController = StreamController<void>.broadcast();
  Stream<void> get onChange => _changeController.stream;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('bio_calc_v2.db'); // Incremented version name
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        input TEXT NOT NULL,
        output TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        isFavorite INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<void> insertCalculation({
    required String type,
    required Map<String, dynamic> inputMap,
    required String output,
  }) async {
    try {
      final db = await instance.database;
      await db.insert('history', {
        'type': type,
        'input': jsonEncode(inputMap),
        'output': output,
        'timestamp': DateTime.now().toIso8601String(),
        'isFavorite': 0,
      });
      _changeController.add(null);
    } catch (e) {
      print("DATABASE ERROR: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    try {
      final db = await instance.database;
      return await db.query('history', orderBy: 'timestamp DESC');
    } catch (e) {
      return [];
    }
  }

  Future<void> deleteEntry(int id) async {
    final db = await instance.database;
    await db.delete('history', where: 'id = ?', whereArgs: [id]);
    _changeController.add(null);
  }

  Future<void> clearAll() async {
    final db = await instance.database;
    await db.delete('history');
    _changeController.add(null);
  }
}