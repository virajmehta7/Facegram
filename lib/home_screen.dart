import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facegram/other_users_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthService authService = new AuthService();
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Facegram',
          style: TextStyle(color: Colors.black, fontSize: 28, fontFamily: 'Satisfy', fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(
                  context, MaterialPageRoute(
                  builder: (context) => Search())
              );
            },
            icon: Icon(Icons.search, color: Colors.black, size: 26),
          )
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("posts")
                .orderBy("postedAt", descending: true)
                .snapshots(),
            builder: (context, snapshot){
              return snapshot.hasData ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) => Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("users")
                                .where("username", isEqualTo: snapshot.data.docs[index]['username'])
                                .snapshots(),
                            builder: (context, snapshot){
                              if(!snapshot.hasData)
                                return Center(
                                    child: CircularProgressIndicator(color: Colors.blue)
                                );
                              return snapshot.data.docs[0]['photo'] != null ?
                              Padding(
                                padding: EdgeInsets.fromLTRB(15,0,15,10),
                                child: Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(80),
                                      image: DecorationImage(
                                          image: NetworkImage(snapshot.data.docs[0]['photo']),
                                          fit: BoxFit.cover
                                      )
                                  ),
                                ),
                              ) :
                              Padding(
                                padding: EdgeInsets.fromLTRB(15,0,15,10),
                                child: Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(80),
                                      image: DecorationImage(
                                          image: AssetImage("assets/profile.png"),
                                          fit: BoxFit.cover
                                      )
                                  ),
                                ),
                              );
                            },
                          ),
                          GestureDetector(
                            child: Text(snapshot.data.docs[index]['username'],
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                            ),
                            onTap: (){
                              Navigator.push(
                                  context, MaterialPageRoute(
                                  builder: (context) => OtherUsersProfile(userName: snapshot.data.docs[index]['username'],))
                              );
                            },
                          ),
                        ],
                      ),
                      Image.network(snapshot.data.docs[index]['photoPost']),
                      snapshot.data.docs[index]["caption"].toString().isNotEmpty ? Padding(
                        padding: EdgeInsets.fromLTRB(10,10,10,0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              child: Text(snapshot.data.docs[index]['username'],
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              onTap: (){
                                Navigator.push(
                                    context, MaterialPageRoute(
                                    builder: (context) => OtherUsersProfile(userName: snapshot.data.docs[index]['username'],))
                                );
                              },
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(snapshot.data.docs[index]["caption"],
                                style: TextStyle(fontSize: 18)
                                ,maxLines: null,
                              ),
                            )
                          ],
                        ),
                      ) : Container(),
                      Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ],
                  ),
                ),
              ) : CircularProgressIndicator();
            }
        ),
      ),
    );
  }
}