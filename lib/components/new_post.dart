import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:wastegram/models/waste_info.dart';

class NewPost extends StatelessWidget {
  NewPost(
      {required this.image, required this.imageURL, required this.updateTotal});

  final File image;
  final imageURL;
  final Function(int) updateTotal;
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    void createPost() async {
      final location = Location();
      final position = await location.getLocation();
      final weight = textController.text.trim();

      final wastePost = WastePost(
          weight: weight.toString(),
          location: '${position.latitude}, ${position.longitude}',
          imageURL: imageURL.toString(),
          dateTime: DateTime.now());

      await FirebaseFirestore.instance
          .collection('posts')
          .add(wastePost.toMap());

      updateTotal(int.parse(weight));

      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("New Post Entry"),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: Column(children: [
          SizedBox(height: 220, width: 250, child: Image.file(image)),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Semantics(
              button: false,
              onTapHint:
                  "Text field to enter a number: the amount of wasted food",
              label: "Enter amount wasted",
              child: TextFormField(
                controller: textController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: 'Enter amount wasted '),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a number';
                  }
                  return null;
                },
              ),
            ),
          ),
          Semantics(
            button: true,
            onTapHint: "Press this button to add wasted data",
            label: "Add waste information button",
            child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    createPost();
                  }
                },
                child: Text('Add Waste')),
          )
        ]),
      ),
    );
  }
}
