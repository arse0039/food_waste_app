import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'new_post.dart';
import 'show_entry.dart';

class ListScreen extends StatefulWidget {
  @override
  ListScreenState createState() => ListScreenState();
}

class ListScreenState extends State<ListScreen> {
  final picker = ImagePicker();
  int totalWaste = 0;

  void updateTotal(int value) {
    setState(() => {totalWaste += value});
  }

  void chooseImage() async {
    final chosenImage = await picker.pickImage(source: ImageSource.gallery);
    final File imageFile = File(chosenImage!.path);
    final Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('image/${DateTime.now().toString()}');
    final UploadTask uploadTask = storageReference.putFile(imageFile);
    await uploadTask.whenComplete(() => null);
    final imageURL = await storageReference.getDownloadURL();

    if (chosenImage != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewPost(
                image: imageFile, imageURL: imageURL, updateTotal: updateTotal),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(centerTitle: true, title: Text('Wastegram: ${totalWaste}')),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .orderBy('dateTime', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var post = snapshot.data!.docs[index];
                    final weight = post['weight'];
                    final date = post['dateTime'].toDate();
                    final location = post['location'];

                    final formattedDate =
                        DateFormat('EEEE, MMMM, d, y').format(date);
                    return Semantics(
                      onTapHint:
                          "Press tile to see specifics about this waste post",
                      label: "Open details page for this waste post",
                      child: ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(formattedDate,
                                  style: TextStyle(fontSize: 18)),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xfffdfdff),
                              ),
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                post['weight'].toString(),
                                style: TextStyle(fontSize: 27),
                              ),
                            )
                          ],
                        ),
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShowEntry(entry: post)))
                        },
                      ),
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => chooseImage(),
        tooltip: 'Add Entry',
        child: Semantics(
            child: Icon(Icons.add_a_photo),
            button: true,
            onTapHint:
                "Press this button to select a photo and open the waste data page",
            label: "Add new"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
