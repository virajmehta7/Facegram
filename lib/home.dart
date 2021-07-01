import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Facegram',
              style: TextStyle(fontSize: 45, fontFamily: 'Satisfy', fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 60),
            ElevatedButton(
              onPressed: (){
                Navigator.push(
                    context, MaterialPageRoute(
                    builder: (context) => Register())
                );
              },
              child: Text('Create New Account',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: EdgeInsets.fromLTRB(90, 15, 90, 15),
              ),
            ),
            SizedBox(height: 25),
            TextButton(
              onPressed: (){
                Navigator.push(
                    context, MaterialPageRoute(
                    builder: (context) => Login())
                );
              },
              child: Text('Log in',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(90, 15, 90, 15)
              ),
            )
          ],
        ),
      ),
    );
  }
}