import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{

  uploadUserInfo(userMap){
    FirebaseFirestore.instance.collection("users").add(userMap);
  }

  usernameCheck(String username) async {
    final result = await FirebaseFirestore.instance
        .collection("users")
        .where('username', isEqualTo: username)
        .get();
    return result.docs.isEmpty;
  }

  searchUser(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where('username', isEqualTo: username)
        .get();
  }

  updateProfilePic(String username, String photo) async {
    await FirebaseFirestore.instance
        .collection("users")
        .where('username', isEqualTo: username)
        .get().then((docs){
          FirebaseFirestore.instance
              .doc('/users/${docs.docs[0].id}')
              .update({'photo': photo});
    });
  }

  updateName(String username, String name) async {
    await FirebaseFirestore.instance
        .collection("users")
        .where('username', isEqualTo: username)
        .get().then((docs) {
          FirebaseFirestore.instance
              .doc('/users/${docs.docs[0].id}')
              .update({'name': name});
    });
  }

  updateBio(String username, String bio) async {
    await FirebaseFirestore.instance
        .collection("users")
        .where('username', isEqualTo: username)
        .get().then((docs) {
          FirebaseFirestore.instance
              .doc('/users/${docs.docs[0].id}')
              .update({'bio': bio});
    });
  }

  uploadPost(String username, String post, String caption, time) async {
    await FirebaseFirestore.instance
        .collection("posts")
        .add({'username': username, 'photoPost': post, 'caption': caption, 'postedAt': time});
  }

}