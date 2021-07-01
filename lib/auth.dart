import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  _User _userFromFirebase(User user){
    return user != null ? _User(uid: user.uid) : null;
  }

  Future signIn(String email, String password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, password: password
    );
    User user = result.user;
    return _userFromFirebase(user);
  }

  Future createUser(String username, String email, String password) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password
    );
    User user = result.user;
    user.updateDisplayName(username);
    return _userFromFirebase(user);
  }

  Future resetPassword(String email) async{
    try{
      return await _auth.sendPasswordResetEmail(
          email: email
      );
    } catch(e){
      print(e.toString());
    }
  }

  Future signOut() async{
    try{
      return await _auth.signOut();
    } catch(e){
      print(e.toString());
    }
  }
}

class _User{
  final String uid;
  _User({this.uid});
}