import 'package:flutter/material.dart';
import 'auth.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = new TextEditingController();
  AuthService authService = new AuthService();

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
              ElevatedButton(
                onPressed: (){
                  if (_formKey.currentState.validate()){
                    authService.resetPassword(email.text);
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