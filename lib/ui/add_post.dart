import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'upload_post.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key key}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  File imgPost;

  cropImage(ImageSource source) async {
    final tempImage = await ImagePicker().getImage(source: source, imageQuality: 90);
    if(tempImage != null) {
      File croppedFile = await ImageCropper.cropImage(
        sourcePath: tempImage.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: "Edit Photo",
          toolbarColor: Colors.white,
          toolbarWidgetColor: Colors.blue,
          activeControlsWidgetColor: Colors.blue
        )
      );
      setState(() {
        imgPost = croppedFile;
      });
      if(imgPost != null){
        Navigator.push(
            context, MaterialPageRoute(
            builder: (context) => UploadPost(imgPost: imgPost))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SimpleDialog(
          title: Text('Create Post',
              style: TextStyle(color: Colors.blue, fontSize: 21)
          ),
          children: [
            SimpleDialogOption(
              child: Text("Choose from Gallery",
                  style: TextStyle(fontSize: 16)),
              onPressed: (){
                cropImage(ImageSource.gallery);
              },
            ),
            SimpleDialogOption(
              child: Text("Take photo",
                  style: TextStyle(fontSize: 16)
              ),
              onPressed: (){
                cropImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }
}