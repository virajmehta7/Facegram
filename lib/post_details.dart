import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'auth.dart';

class PostDetails extends StatefulWidget {
  final int index;
  const PostDetails({Key key, this.index}) : super(key: key);

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  AuthService authService = new AuthService();
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("posts")
                .where("username", isEqualTo: currentUser.displayName)
                .orderBy("postedAt", descending: true)
                .snapshots(),
            builder: (context, snapshot){
              return snapshot.hasData ? Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .where("username", isEqualTo: currentUser.displayName)
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
                      Text(currentUser.displayName,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  Image.network(snapshot.data.docs[widget.index]['photoPost']),
                  snapshot.data.docs[widget.index]["caption"].toString().isNotEmpty ?
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(currentUser.displayName,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(snapshot.data.docs[widget.index]["caption"],
                            style: TextStyle(fontSize: 18),
                            maxLines: null,
                          ),
                        )
                      ],
                    ),
                  ) : Container()
                ],
              ) : Container();
            }
        ),
      ),
    );
  }
}