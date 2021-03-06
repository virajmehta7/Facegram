import 'package:facegram/ui/home.dart';
import 'package:facegram/ui/screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  runApp(
      MaterialApp(
        home: email == null ? Home() : Screen(),
        debugShowCheckedModeBanner: false,
      )
  );
}