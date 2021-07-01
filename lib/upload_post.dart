import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'database.dart';
import 'dart:io';

class UploadPost extends StatefulWidget {
  final File imgPost;
  const UploadPost({Key key, this.imgPost}) : super(key: key);

  @override
  _UploadPostState createState() => _UploadPostState();
}

class _UploadPostState extends State<UploadPost> {
  TextEditingController caption = new TextEditingController();
  var currentUser = FirebaseAuth.instance.currentUser;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.close),
          color: Colors.black,
          iconSize: 28,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            color: Colors.blue,
            iconSize: 28,
            onPressed: (){
              if(widget.imgPost != null){
                FirebaseStorage storage = FirebaseStorage.instance;
                Reference ref = storage.ref().child(currentUser.displayName + "-post-" + DateTime.now().toString());
                UploadTask task = ref.putFile(widget.imgPost);
                task.whenComplete(() async {
                  url = await ref.getDownloadURL();
                  await databaseMethods.uploadPost(currentUser.displayName, url, caption.text.trim(), Timestamp.now());
                }).catchError((e){
                  print(e);
                });
              }
              Navigator.pop(context);
            },
          )
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 18, 15, 18),
              child: Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5)
                      ),
                      border: Border.all(
                        color: Colors.black,
                        width: 1
                      ),
                      image: DecorationImage(
                        image: FileImage(widget.imgPost),
                        fit: BoxFit.cover
                      )
                  ),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(15, 18, 15, 10),
                child: TextField(
                  controller: caption,
                  style: TextStyle(fontSize: 18),
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: "Write a caption...",
                    hintStyle: TextStyle(fontSize: 16)
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}