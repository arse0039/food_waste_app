import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wastegram/models/waste_info.dart';

void main() {
  test('toMap creates the appropriate map from a WastePost object', () {
    final post = WastePost(
      weight: '47',
      location: '100, 200',
      imageURL: 'http://google.com',
      dateTime: DateTime.now(),
    );
    final result = post.toMap();
    expect(result['weight'], '47');
    expect(result['location'], '100, 200');
    expect(result['imageURL'], 'http://google.com');
    expect(result['dateTime'], isA<Timestamp>());
  });

  test('fromMap can be used to create a WastePost object', () {
    final wasteMap = {
      'weight': '47',
      'location': '100, 200',
      'imageURL': 'http://google.com',
      'dateTime': Timestamp.fromDate(DateTime(2023, 3, 14)),
    };
    final post = WastePost.fromMap(wasteMap);
    expect(post.weight, '47');
    expect(post.location, '100, 200');
    expect(post.imageURL, 'http://google.com');
    expect(post.dateTime, DateTime(2023, 3, 14));
  });
}
