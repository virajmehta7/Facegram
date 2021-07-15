import 'package:facegram/services/auth.dart';
import 'package:facegram/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'screen.dart';

class Register extends StatefulWidget {
  const Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController username = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  String error, userName;
  bool loading = false;

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
      body: loading ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ) :
      Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Icon(Icons.person_outline, color: Colors.blue, size: 60,),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(30,30,30,0),
                      child: TextFormField(
                        controller: username,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[a-z0-9]")),
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderSide: BorderSide()),
                          labelText: 'Username',
                          labelStyle: TextStyle(fontWeight: FontWeight.w500)
                        ),
                        validator: (val){
                          if(val.isEmpty)
                            return 'Username can\'t be empty';
                          else if(val.length < 3)
                            return 'Username must be at least 3 characters';
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(30,20,30,0),
                      child: TextFormField(
                        controller: email,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(borderSide: BorderSide()),
                            labelText: 'Email',
                            labelStyle: TextStyle(fontWeight: FontWeight.w500)
                        ),
                        validator: (val) {
                          if(val.isEmpty)
                            return 'Email can\'t be empty';
                          if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val))
                            return 'Enter a valid email';
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(30,20,30,30),
                      child: TextFormField(
                        controller: password,
                        obscureText: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(borderSide: BorderSide()),
                            labelText: 'Password',
                            labelStyle: TextStyle(fontWeight: FontWeight.w500)
                        ),
                        validator: (value) {
                          if(value.isEmpty)
                            return 'Password can\'t be empty';
                          if(value.length < 8)
                            return 'Password must be at least 8 characters';
                          return null;
                        },
                      ),
                    ),
                  ],
                )
              ),
              ElevatedButton(
                onPressed: () async {
                  final valid = await databaseMethods.usernameCheck(username.text);
                  if (!valid) {
                    setState(() {
                      error = 'The username ${username.text} is not available.';
                    });
                  }
                  else if (_formKey.currentState.validate()) {
                    setState(() {
                      loading = true;
                    });
                    try {
                      Map<String, String> userInfoMap = {
                        "username" : username.text,
                        "email" : email.text,
                        "name" : "",
                        "photo" : null,
                        "bio" : ""
                      };
                      dynamic result = await authService.createUser(
                          username.text, email.text.trim(), password.text.trim()
                      );
                      databaseMethods.uploadUserInfo(userInfoMap);
                      if (result != null) {
                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString('email', email.text);
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => Screen()),
                                (Route<dynamic> route) => false
                        );
                      }
                    } catch (e) {
                      setState(() {
                        error = e.message;
                        loading = false;
                      });
                    }
                  }
                },
                child: Text('Sign up',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: EdgeInsets.fromLTRB(60,12,60,12),
                ),
              ),
              SizedBox(height: 30),
              showAlert(),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? ',
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.push(
                          context, MaterialPageRoute(
                          builder: (context) => Login())
                      );
                    },
                    child: Text('Sign in',
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.blue),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}