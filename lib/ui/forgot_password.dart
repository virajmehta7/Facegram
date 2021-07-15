import 'package:facegram/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = new TextEditingController();
  AuthService authService = new AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String error;

  Widget showAlert() {
    if (error != null) {
      return Container(
        color: Colors.blue,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline_sharp, color: Colors.white,),
            ),
            Expanded(
              child: Text(error,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white,),
                onPressed: () {
                  setState(() {
                    error = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Find Your Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 15),
              Text('Enter your email linked to your account.',
                style: TextStyle(fontSize: 16),
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(30,30,30,20),
                  child: TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide()),
                        labelText: 'Email',
                        labelStyle: TextStyle(fontWeight: FontWeight.w500)
                    ),
                    validator: (value) {
                      if(value.isEmpty)
                        return 'Email can\'t be empty';
                      if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value))
                        return 'Enter a valid email';
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: showAlert(),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()){
                    try {
                      await _auth.sendPasswordResetEmail(
                          email: email.text
                      );
                      setState(() {
                        showDialog(
                          context: context,
                            builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Password Reset Email Sent"),
                              content: Text("An email has been sent to ${email.text} "),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Ok'),
                                )
                              ],
                            );
                          }
                        );
                      });
                    } catch(e) {
                      setState(() {
                        error = e.message;
                      });
                    }
                  }
                },
                child: Text('Send password reset email',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: EdgeInsets.fromLTRB(50,12,50,12),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}