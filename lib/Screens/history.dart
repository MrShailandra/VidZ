import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vidg/Services/jitsiMeetService.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  String name,email;
  JitsiMeets meets = JitsiMeets();
  getUserData() async {
    final databaseReference = FirebaseDatabase.instance
        .reference()
        .child(FirebaseAuth.instance.currentUser.uid);
    databaseReference.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      name = values["name"];
      email = values["email"];
    });
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('meetings');
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Container(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("meetings")
                    .where("email",
                        isEqualTo: email)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> querySnapShot) {
                  if (querySnapShot.hasError) {
                    return Center(
                      child: Text("Something Went Wrong"),
                    );
                  }
                  if (querySnapShot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    final list = querySnapShot.data.docs;

                    return ListView.builder(
                        itemCount: list.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Container(
                              height: 80,
                              margin: EdgeInsets.only(bottom: 13),
                              padding: EdgeInsets.only(
                                  left: 24, top: 12, bottom: 12, right: 22),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x10000000),
                                    blurRadius: 10,
                                    spreadRadius: 5,
                                    offset: Offset(8.0, 8.0),
                                  )
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image:
                                                AssetImage("assets/logo.png"),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 13,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "Subject -: ${list[index]["Subject"]}",
                                            style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "ID-: ${list[index]["ID"]}",
                                            style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Time-: ${list[index]["time"]}",
                                            style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  MaterialButton(
                                    onPressed: () async {
                                      // if (_formKey.currentState.validate()) {
                                      meets.JoinMeeting(list[index]["ID"], name, email,
                                          list[index]["Subject"], true, true);
                                      // }
                                    },
                                    child: Text(
                                      'ReJoin'.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    color: Color(0xffff2d55),
                                    elevation: 0,
                                    height: 40,
                                    minWidth: 20,
                                    textColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }
                  return Center();
                }),
          ),
        ),
      ),
    );
  }
}
