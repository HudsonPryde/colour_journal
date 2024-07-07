import 'dart:typed_data';

import 'package:flutter/material.dart';

class Card {
  final String _id;
  final Color _colour;
  final Uint8List? _image;
  final String _collectionId;
  String _name;

  Card(this._id, this._name, this._colour, this._image, this._collectionId);

  List<int> get rgb => [_colour.red, _colour.green, _colour.blue];
  String get hex => '#${_colour.value.toRadixString(16).substring(2)}';
  Color get colour => _colour;
  String get id => _id;
  String get collectionId => _collectionId;
  Uint8List? get cutout => _image;
  String get name => _name;

  void rename(String name) {
    _name = name;
  }

  Map<String, Object?> toMap() {
    return {
      'card_id': _id,
      'name': _name,
      'colour': _colour.value,
      'image': _image,
      'collection_id': _collectionId,
    };
  }

  factory Card.fromMap(Map<String, dynamic> map) {
    return Card(
      map['card_id'],
      map['name'] ?? "",
      Color(map['colour']),
      map['image'] as Uint8List,
      map['collection_id'],
    );
  }
}
