import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShowEntry extends StatelessWidget {
  final QueryDocumentSnapshot entry;
  ShowEntry({required this.entry});

  @override
  Widget build(BuildContext context) {
    final weight = entry['weight'];
    final date = entry['dateTime'].toDate();
    final location = entry['location'];
    final imageURL = entry['imageURL'];

    final formattedDate = DateFormat('EEEE, MMMM, d, y').format(date);
    return (Scaffold(
        appBar: AppBar(
          title: Text("Wastegram"),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(formattedDate,
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 23)),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Image.network(imageURL),
            ),
            Text(weight.toString(), style: TextStyle(fontSize: 18)),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 159, 0, 0),
              child: Text(location),
            ),
          ],
        )));
  }
}
