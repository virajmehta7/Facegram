import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth.dart';
import 'forgot_password.dart';
import 'register.dart';
import 'screen.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  AuthService authService = new AuthService();
  String error;
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
      body: loading? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ) :
      Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Facegram',
                style: TextStyle(fontSize: 45, fontFamily: 'Satisfy', fontWeight: FontWeight.bold),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(30,30,30,0),
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
                    Padding(
                      padding: EdgeInsets.fromLTRB(30,20,30,0),
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
                          return null;
                        },
                      ),
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.fromLTRB(0,15,30,40),
                child: InkWell(
                  onTap: (){
                    Navigator.push(
                        context, MaterialPageRoute(
                        builder: (context) => ForgotPassword())
                    );
                  },
                  child: Text('Forgot password?',
                      style: TextStyle(fontWeight: FontWeight.w400)
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    setState(() {
                      loading = true;
                    });
                    try {
                      dynamic result = await authService.signIn(
                          email.text.trim(), password.text.trim()
                      );
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
                child: Text('Log in',
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
                  Text('Don\'t have an account? ',
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.push(
                          context, MaterialPageRoute(
                          builder: (context) => Register())
                      );
                    },
                    child: Text('Sign up',
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