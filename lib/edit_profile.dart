import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'database.dart';
import 'dart:io';

class EditProfile extends StatefulWidget {
  const EditProfile({Key key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController name = new TextEditingController();
  TextEditingController bio = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  var currentUser = FirebaseAuth.instance.currentUser;
  var profilePicUrl = "assets/profile.png";
  File profilePic;
  String url, userBio, userName;

  @override
  void initState() {
    super.initState();
    setState(() {
      if(currentUser.photoURL != null){
        profilePicUrl = currentUser.photoURL;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile',
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
              if(profilePic != null){
                FirebaseStorage storage = FirebaseStorage.instance;
                Reference ref = storage.ref().child(currentUser.displayName + "-profilePic-" + DateTime.now().toString());
                UploadTask task = ref.putFile(profilePic);
                task.whenComplete(() async {
                  url = await ref.getDownloadURL();
                  await databaseMethods.updateProfilePic(currentUser.displayName, url);
                  await FirebaseAuth.instance.currentUser.updatePhotoURL(url);
                }).catchError((e){
                  print(e);
                });
              }
              if(bio.text.isNotEmpty){
                userBio = bio.text.trim();
                databaseMethods.updateBio(currentUser.displayName, userBio);
              }
              if(name.text.isNotEmpty){
                userName = name.text.trim();
                databaseMethods.updateName(currentUser.displayName, userName);
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
            profilePic == null ? Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: Center(
                child: Container(
                  width: 110.0,
                  height: 110.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                    image: DecorationImage(
                      image: currentUser.photoURL != null? NetworkImage(profilePicUrl) : AssetImage(profilePicUrl),
                      fit: BoxFit.cover
                    )
                  ),
                ),
              ),
            ) :
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: Center(
                child: Container(
                  width: 110.0,
                  height: 110.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(80),
                      image: DecorationImage(
                          image: FileImage(profilePic),
                          fit: BoxFit.cover
                      )
                  ),
                ),
              ),
            ),
            GestureDetector(
              child: Center(
                child: Text("Change Photo",
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return SimpleDialog(
                        children: [
                          SimpleDialogOption(
                            child: Text("Choose from Gallery",
                                style: TextStyle(fontSize: 16)),
                            onPressed: () async {
                              var tempImage = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 75);
                              setState(() {
                                profilePic = File(tempImage.path);
                              });
                              Navigator.pop(context);
                            },
                          ),
                          SimpleDialogOption(
                            child: Text("Take photo",
                                style: TextStyle(fontSize: 16)
                            ),
                            onPressed: () async {
                              var tempImage = await ImagePicker().getImage(source: ImageSource.camera, imageQuality: 75);
                              setState(() {
                                profilePic = File(tempImage.path);
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    }
                );
              },
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: Text("Name",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: TextField(
                  controller: name,
                  style: TextStyle(fontSize: 18),
                )
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 18, 15, 0),
              child: Text("Bio",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: TextField(
                controller: bio,
                style: TextStyle(fontSize: 18),
                maxLength: 100,
                maxLines: null,
              )
            ),
            Divider(height: 60, color: Colors.grey),
            Padding(
              padding: EdgeInsets.only(left: 15, top: 5),
              child: Text("Private Information",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 20, 0 ,0),
              child: Text("Email address",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 0, 10),
              child: Text(currentUser.email,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}