import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'dao/card.dart';
import 'dao/collection.dart';

class DatabaseService {
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    final path = join(databasePath, 'colour_journal.db');

    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE collections(collection_id TEXT PRIMARY KEY, name TEXT, font TEXT DEFAULT "Coconat", created_at TEXT)');
    await db.execute(
        'CREATE TABLE cards(card_id TEXT PRIMARY KEY, name TEXT, colour INTEGER, image BLOB, collection_id TEXT NOT NULL, FOREIGN KEY (collection_id) REFERENCES collections (collection_id))');
  }

  Future<void> execute(String sql) async {
    try {
      final Database db = await _databaseService.database;
      await db.execute(sql);
    } catch (err) {
      print(err);
    }
  }

  Future<void> insertCard(Card card) async {
    final Database db = await _databaseService.database;
    await db.insert('cards', card.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> renameCard(String name, String id) async {
    final Database db = await _databaseService.database;
    await db.update('cards', {'name': name},
        where: 'card_id = ?', whereArgs: [id]);
  }

  Future<void> renameCollection(String name, String id) async {
    final Database db = await _databaseService.database;
    await db.update('collections', {'name': name},
        where: 'collection_id = "$id"');
  }

  Future<void> insertCollection(Collection collection) async {
    final Database db = await _databaseService.database;
    await db.insert('collections', collection.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateCollectionFont(String font, String id) async {
    final Database db = await _databaseService.database;
    await db.update('collections', {'font': font},
        where: 'collection_id = ?', whereArgs: [id]);
  }

  Future<List<Collection>> collections() async {
    final Database db = await _databaseService.database;

    // get all the stored collections from the db
    final List<Map<String, Object?>> colMaps = await db.query('collections');
    List<Collection> storedCollections = List.generate(
        colMaps.length, (index) => Collection.fromMap(colMaps[index]));
    // find their respective cards and assign them
    for (Collection col in storedCollections) {
      // get the cards by colleciton id
      final List<Map<String, Object?>> cardMaps =
          await db.query('cards', where: 'collection_id="${col.id}"');
      col.cards = List.generate(
          cardMaps.length, (index) => Card.fromMap(cardMaps[index]));
    }

    return storedCollections;
  }

  Future<List<Card>> getCardsFromCollection(String collectionId) async {
    final Database db = await _databaseService.database;

    final List<Map<String, Object?>> cardMaps =
        await db.query('cards', where: 'collection_id="$collectionId"');
    return List.generate(
        cardMaps.length, (index) => Card.fromMap(cardMaps[index]));
  }

  Future<void> deleteCard(String id) async {
    final db = await _databaseService.database;
    await db.delete('cards', where: 'card_id = ?', whereArgs: [id]);
  }

  Future<void> deleteCollection(String id) async {
    final db = await _databaseService.database;
    await db.delete('collections', where: 'collection_id = ?', whereArgs: [id]);
  }
}
