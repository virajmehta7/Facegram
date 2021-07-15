import 'package:cached_network_image/cached_network_image.dart';
import 'package:facegram/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profile.dart';
import 'home.dart';
import 'post_details.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  AuthService authService = new AuthService();
  final currentUser = FirebaseAuth.instance.currentUser;
  bool gridActive = true;
  Color gridColor = Colors.blue;
  Color listColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentUser.displayName,
          style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w600),
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            itemBuilder: (context) {
              return [
                PopupMenuItem(child: Text('Edit Profile'), value: 0),
                PopupMenuItem(child: Text('Logout'), value: 1)
              ];
            },
            onSelected: (value) async {
              if(value == 0){
                Navigator.push(
                    context, MaterialPageRoute(
                    builder: (context) => EditProfile())
                );
              }
              if(value == 1){
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('email');
                authService.signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Home()
                    )
                );
              }
            },
          )
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        snapshot.data.docs[0]['photo'] != null ?
                        Padding(
                          padding: EdgeInsets.fromLTRB(15,15,0,10),
                          child: Container(
                            width: 110.0,
                            height: 110.0,
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
                          padding: EdgeInsets.fromLTRB(15,15,0,10),
                          child: Container(
                            width: 110.0,
                            height: 110.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(80),
                                image: DecorationImage(
                                    image: AssetImage("assets/profile.png"),
                                    fit: BoxFit.cover
                                )
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 50),
                          child: Column(
                            children: [
                              Text("Posts",
                                  style: TextStyle(color: Colors.black, fontSize: 22)
                              ),
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("posts")
                                    .where("username", isEqualTo: currentUser.displayName)
                                    .snapshots(),
                                builder: (context, snapshot){
                                  if(!snapshot.hasData)
                                    return Container();
                                  final doc = snapshot.data.docs;
                                  return Text(doc.length.toString(),
                                    style: TextStyle(fontWeight: FontWeight.w300, color: Colors.black, fontSize: 20),
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    snapshot.data.docs[0]['name'].toString().isNotEmpty ?
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10,5,10,0),
                      child: Text(snapshot.data.docs[0]['name'],
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ) :
                    Container(),
                    snapshot.data.docs[0]['bio'].toString().isNotEmpty ?
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10,5,10,0),
                      child: Text(snapshot.data.docs[0]['bio'],
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                      ),
                    ) :
                    Container()
                  ],
                );
              },
            ),
            Divider(color: Colors.grey),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.grid_on, color: gridColor, size: 30),
                  onPressed: (){
                    setState(() {
                      gridActive = true;
                      gridColor = Colors.blue;
                      listColor = Colors.black;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.list_alt, color: listColor, size: 30),
                  onPressed: (){
                    setState(() {
                      gridActive = false;
                      gridColor = Colors.black;
                      listColor = Colors.blue;
                    });
                  },
                )
              ],
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("posts")
                  .where("username", isEqualTo: currentUser.displayName)
                  .orderBy("postedAt", descending: true)
                  .snapshots(),
              builder: (context, snapshot){
                return snapshot.hasData ? gridActive ? GridView.builder(
                  cacheExtent: 9999,
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2),
                  itemBuilder: (context, index){
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context, MaterialPageRoute(
                            builder: (context) => PostDetails(index: index))
                        );
                      },
                      child: CachedNetworkImage(
                        imageUrl: snapshot.data.docs[index]['photoPost'],
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    );
                  },
                ) : ListView.builder(
                  cacheExtent: 9999,
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, index) => Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
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
                        CachedNetworkImage(
                          imageUrl: snapshot.data.docs[index]['photoPost'],
                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                              CircularProgressIndicator(value: downloadProgress.progress),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        snapshot.data.docs[index]["caption"].toString().isNotEmpty ? Padding(
                          padding: EdgeInsets.fromLTRB(10,10,10,0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(currentUser.displayName,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(snapshot.data.docs[index]["caption"],
                                  style: TextStyle(fontSize: 18),
                                  maxLines: null,
                                ),
                              )
                            ],
                          ),
                        ) : Container(),
                        Divider(
                            color: Colors.black
                        ),
                      ],
                    ),
                  ),
                ) : Container();
              },
            )
          ],
        ),
      ),
    );
  }
}