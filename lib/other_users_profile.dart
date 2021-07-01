import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OtherUsersProfile extends StatefulWidget {
  final String userName;
  const OtherUsersProfile({Key key, this.userName}) : super(key: key);

  @override
  _OtherUsersProfileState createState() => _OtherUsersProfileState();
}

class _OtherUsersProfileState extends State<OtherUsersProfile> {
  bool gridActive = true;
  Color gridColor = Colors.blue;
  Color listColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName,
          style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .where("username", isEqualTo: widget.userName)
                  .snapshots(),
              builder: (context, snapshot){
                if(!snapshot.hasData)
                  return Center(
                      child: CircularProgressIndicator(color: Colors.blue)
                  );
                return snapshot.data.docs[0]['photo'] != null ?
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
                );
              },
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .where("username", isEqualTo: widget.userName)
                  .snapshots(),
              builder: (context, snapshot){
                if(!snapshot.hasData)
                  return Container();
                return snapshot.data.docs[0]['name'].toString().isNotEmpty ?
                Padding(
                  padding: const EdgeInsets.fromLTRB(10,5,10,0),
                  child: Text(snapshot.data.docs[0]['name'],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ) :
                Container();
              },
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .where("username", isEqualTo: widget.userName)
                  .snapshots(),
              builder: (context, snapshot){
                if(!snapshot.hasData)
                  return Container();
                return snapshot.data.docs[0]['bio'].toString().isNotEmpty ?
                Padding(
                  padding: const EdgeInsets.fromLTRB(10,5,10,0),
                  child: Text(snapshot.data.docs[0]['bio'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                  ),
                ) :
                Container();
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
            gridActive ? StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("posts")
                  .where("username", isEqualTo: widget.userName)
                  .orderBy("postedAt", descending: true)
                  .snapshots(),
              builder: (context, snapshot){
                return snapshot.hasData ? GridView.builder(
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2),
                  itemBuilder: (context, index){
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context, MaterialPageRoute(
                            builder: (context) => OtherUsersPostDetails(index: index, userName: widget.userName))
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: new NetworkImage(snapshot.data.docs[index]['photoPost']),
                                fit: BoxFit.cover
                            )
                        ),
                      ),
                    );
                  },
                ) : Container();
              },
            ) : StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("posts")
                    .where("username", isEqualTo: widget.userName)
                    .orderBy("postedAt", descending: true)
                    .snapshots(),
                builder: (context, snapshot){
                  return snapshot.hasData ? ListView.builder(
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
                                    .where("username", isEqualTo: widget.userName)
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
                              Text(widget.userName,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          Image.network(snapshot.data.docs[index]['photoPost']),
                          snapshot.data.docs[index]["caption"].toString().isNotEmpty ? Padding(
                            padding: EdgeInsets.fromLTRB(10,10,10,0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.userName,
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
                              color: Colors.grey
                          ),
                        ],
                      ),
                    ),
                  ) : Container();
                }
            ),
          ],
        ),
      ),
    );
  }
}

class OtherUsersPostDetails extends StatefulWidget {
  final int index;
  final String userName;
  const OtherUsersPostDetails({Key key, this.index, this.userName}) : super(key: key);

  @override
  _OtherUsersPostDetailsState createState() => _OtherUsersPostDetailsState();
}

class _OtherUsersPostDetailsState extends State<OtherUsersPostDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts",
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("posts")
                .where("username", isEqualTo: widget.userName)
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
                            .where("username", isEqualTo: widget.userName)
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
                      Text(widget.userName,
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
                        Text(widget.userName,
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