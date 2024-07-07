import 'dart:collection';

import 'package:colour_journal/dao/card.dart';
import 'package:colour_journal/database.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'package:uuid/uuid.dart';

var uuid = const Uuid();

final DatabaseService _databaseService = DatabaseService();

class Collection {
  final String _id;
  String _name;
  final String _createdAt;
  String _font;
  List<Card> cards = [];

  Collection(this._id, this._name, this._font, this._createdAt);

  String get id => _id;
  String get name => _name;
  String get font => _font;
  String get createdAt => DateFormat.yMd().format(DateTime.parse(_createdAt));
  String get createdAtVerbose =>
      DateFormat.yMMMMd('en_US').format(DateTime.parse(_createdAt));

  void rename(String name) {
    _name = name;
  }

  void changeFont(String font) {
    _font = font;
  }

  Map<String, Object?> toMap() {
    return {
      'collection_id': _id,
      'name': _name,
      'font': _font,
      'created_at': _createdAt,
    };
  }

  factory Collection.fromMap(Map<String, dynamic> map) {
    return Collection(
        map['collection_id'], map['name'], map['font'], map['created_at']);
  }
}

class CollectionModel extends ChangeNotifier {
  final List<Collection> _collections = [];

  UnmodifiableListView<Collection> get collections =>
      UnmodifiableListView(_collections);

  void loadCollections() async {
    final List<Collection> storedCollections =
        await _databaseService.collections();
    set(storedCollections);
  }

  Future<List<Card>> loadCards(collectionId) async {
    final List<Card> collectionCards =
        await _databaseService.getCardsFromCollection(collectionId);
    return collectionCards;
  }

  void deleteCards(collectionId) async {
    final List<Card> storedCollections =
        await _databaseService.getCardsFromCollection(collectionId);
    for (var e in storedCollections) {
      await _databaseService.deleteCard(e.id);
    }
  }

  void deleteCard(Card card) async {
    await _databaseService.deleteCard(card.id);
    collections
        .firstWhere((collection) => collection.id == card.collectionId)
        .cards
        .removeWhere((c) => c.id == card.id);
    notifyListeners();
  }

  void deleteCollection(String id) async {
    await _databaseService.deleteCollection(id);
    _collections.removeWhere((collection) => collection.id == id);
    notifyListeners();
  }

  void addCollection(Collection collection) {
    _collections.add(collection);
    notifyListeners();
  }

  void addCard(Card card, collectionId) {
    try {
      Collection target =
          _collections.firstWhere((col) => col.id == collectionId);
      target.cards.add(card);
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  void renameCard(String name, String cardId, String collectionId) async {
    await _databaseService.renameCard(name, cardId);
    _collections
        .firstWhere((col) => col.id == collectionId)
        .cards
        .firstWhere((card) => card.id == cardId)
        .rename(name);
    notifyListeners();
  }

  void renameCollection(String name, String id) async {
    await _databaseService.renameCollection(name, id);
    _collections.firstWhere((col) => col.id == id).rename(name);
    notifyListeners();
  }

  void changeCollectionFont(String font, String id) async {
    await _databaseService.updateCollectionFont(font, id);
    _collections.firstWhere((col) => col.id == id).changeFont(font);
    notifyListeners();
  }

  Collection createCollection() {
    String id = uuid.v4();
    String defaultName = 'New Collection #${_collections.length + 1}';
    String defaultTime = DateTime.now().toString();
    Collection newCollection =
        Collection(id, defaultName, "Coconat", defaultTime);
    _databaseService.insertCollection(newCollection);
    _collections.add(newCollection);
    notifyListeners();
    return newCollection;
  }

  Collection getCollectionById(String id) {
    return collections.firstWhere((c) => c.id == id);
  }

  void execute(String sql) async {
    await _databaseService.execute(sql);
  }

  void set(List<Collection> collections) {
    _collections.clear();
    _collections.addAll(collections);
    notifyListeners();
  }

  List<Collection> filterCollectionsByName(String query) {
    if (query.isEmpty) {
      return [];
    }
    return List.from(
      collections.where(
        (collection) =>
            collection._name.toLowerCase().contains(query.toLowerCase()),
      ),
    );
  }
}
