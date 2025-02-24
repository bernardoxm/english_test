import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDataBase {
  static final SqlDataBase _instance = SqlDataBase._internal();
  factory SqlDataBase() => _instance;
  SqlDataBase._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'favorites.db');
    return await openDatabase(
      path,
      version: 2, // Incremented version for schema updates
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            word TEXT NOT NULL,
            isFavorite INTEGER NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            word TEXT NOT NULL,
            viewedAt TEXT NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE history (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              word TEXT NOT NULL,
              viewedAt TEXT NOT NULL
            )
          ''');
        }
      },
    );
  }

  // Função para verificar se a palavra já existe no histórico
  Future<bool> isWordInHistory(String word) async {
    final db = await database;
    final result = await db.query(
      'history',
      where: 'word = ?',
      whereArgs: [word],
    );
    return result.isNotEmpty;
  }

  // Função para verificar se a palavra já existe nos favoritos
  Future<bool> isWordInFavorites(String word) async {
    final db = await database;
    final result = await db.query(
      'favorites',
      where: 'word = ?',
      whereArgs: [word],
    );
    return result.isNotEmpty;
  }

  // Atualizar método de inserção no histórico para evitar duplicatas
  Future<void> insertHistory(String word) async {
    if (!await isWordInHistory(word)) {
      final db = await database;
      await db.insert(
        'history',
        {'word': word, 'viewedAt': DateTime.now().toIso8601String()},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  // Atualizar método de inserção nos favoritos para evitar duplicatas
  Future<void> insertFavorite(String word) async {
    if (!await isWordInFavorites(word)) {
      final db = await database;
      await db.insert(
        'favorites',
        {'word': word, 'isFavorite': 1},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }


  Future<void> deleteFromHistory(String word) async {
    final db = await database;
    final result = await db.delete('history', where: 'word = ?', whereArgs: [word]);
    if (result == 0) {
      throw Exception('Failed to delete word: $word from history.');
    }
  }


  Future<void> deleteFavorite(String word) async {
    final db = await database;
    final result = await db.delete('favorites', where: 'word = ?', whereArgs: [word]);
    if (result == 0) {
      throw Exception('Failed to delete word: $word from favorites.');
    }
  }

   Future<void> deleteallFavorite() async {
        final db = await database;
    await db.delete('favorites');
  }



  Future<List<Map<String, dynamic>>> getHistory() async {
    final db = await database;
    return await db.query('history', orderBy: 'viewedAt DESC');
  }


  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await database;
    return await db.query('favorites', where: 'isFavorite = ?', whereArgs: [1]);
  }


  Future<void> clearHistory() async {
    final db = await database;
    await db.delete('history');
  }

  Future<void> clearHistoryOnly(String word) async {
  final db = await database;
  await db.delete(
    'history',
    where: 'word = ?',
    whereArgs: [word],
  );
}
}
