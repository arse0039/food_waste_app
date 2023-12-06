import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WastePost {
  final String weight;
  final String location;
  final String imageURL;
  final DateTime dateTime;

  WastePost({
    required this.weight,
    required this.location,
    required this.imageURL,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'weight': weight,
      'location': location,
      'imageURL': imageURL,
      'dateTime': Timestamp.fromDate(dateTime),
    };
  }

  factory WastePost.fromMap(Map<String, dynamic> map) {
    return WastePost(
      weight: map['weight'],
      location: map['location'],
      imageURL: map['imageURL'],
      dateTime: (map['dateTime'] as Timestamp).toDate(),
    );
  }
}
