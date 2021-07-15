import 'package:facegram/services/auth.dart';
import 'package:facegram/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'other_users_profile.dart';

class Search extends StatefulWidget {
  const Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController search = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  AuthService authService = new AuthService();
  final currentUser = FirebaseAuth.instance.currentUser;
  QuerySnapshot searchResultSnapshot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Facegram',
          style: TextStyle(color: Colors.black, fontSize: 28, fontFamily: 'Satisfy', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20,5,5,0),
                  child: TextField(
                    controller: search,
                    decoration: InputDecoration(
                      hintText: "Search",
                      hintStyle: TextStyle(color: Colors.black, fontSize: 18)
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5,5,10,0),
                child: IconButton(
                  onPressed: () async {
                    await databaseMethods.searchUser(search.text.trim())
                        .then((val){
                          setState(() {
                            searchResultSnapshot = val;
                          });
                        });
                    },
                  icon: Icon(Icons.search),
                  iconSize: 30,
                  color: Colors.black,
                ),
              )
            ],
          ),
          searchResultSnapshot != null && search.text != currentUser.displayName ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchResultSnapshot.docs.length,
            itemBuilder: (context, index){
              return userTile(
                searchResultSnapshot.docs[index].get("username")
              );
            },
          ) : Container()
        ],
      ),
    );
  }

  Widget userTile(String userName) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Text(userName,
          style: TextStyle(color: Colors.black, fontSize: 18 ),
        ),
      ),
      onTap: (){
        Navigator.push(
            context, MaterialPageRoute(
            builder: (context) => OtherUsersProfile(userName: userName))
        );
      },
    );
  }
}