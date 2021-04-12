import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vidg/Screens/Dashboard.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:vidg/Services/services.dart';
import 'LoginPage.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  firebaseServices services = firebaseServices();
  bool isVisible = true;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController mobile = TextEditingController();
  String userName, userEmail, userMobile;
  bool isLoading = false;

  var result;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    final databaseReference = FirebaseDatabase.instance
        .reference()
        .child(FirebaseAuth.instance.currentUser.uid);
    databaseReference.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      userName = values["name"];
      userEmail = values["email"];
      userMobile = values["number"];
      name.text = userName;
      email.text = userEmail;
      mobile.text = userMobile;
    });
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 40),
                decoration: BoxDecoration(
                  boxShadow: [
                    new BoxShadow(
                      color: Colors.black,
                      blurRadius: 1.0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: <Widget>[
                          Center(
                            child: Text(
                              'Edit Profile',
                              style: GoogleFonts.getFont('Merriweather',
                                  fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                            child: Container(
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: name,
                                validator: (name) {
                                  if (name == null || name.isEmpty) {
                                    return "Name Is Empty";
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Name',
                                    prefixIcon:
                                        Icon(Icons.drive_file_rename_outline),
                                    labelStyle: TextStyle(fontSize: 15)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: Container(
                              child: TextFormField(
                                enabled: false,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: email,
                                keyboardType: TextInputType.emailAddress,
                                validator: (email) {
                                  if (email == null || email.isEmpty) {
                                    return "Email Is Empty";
                                  } else if (validateEmail(email) == false) {
                                    return "Please Enter Valid email";
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Email',
                                    prefixIcon: Icon(Icons.email),
                                    labelStyle: TextStyle(fontSize: 15)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: Container(
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: mobile,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                validator: (mobile) {
                                  if (mobile == null || mobile.isEmpty) {
                                    return "Mobile Is Empty";
                                  } else if (mobile.length != 10) {
                                    return "Please Enter Valid Mobile Number";
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Mobile',
                                    prefixIcon: Icon(Icons.local_phone),
                                    labelStyle: TextStyle(fontSize: 15)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: MaterialButton(
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  services.updateUser(name.text, mobile.text);
                                  if (services.updateUser(
                                          name.text, mobile.text) !=
                                      null) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    _scaffoldKey.currentState.showSnackBar(
                                      new SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        content:
                                            Text("User Updated Successfully"),
                                      ),
                                    );
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DashBoard()));
                                  } else {
                                    _scaffoldKey.currentState.showSnackBar(
                                      new SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        content: Text("Something Went Wrong"),
                                      ),
                                    );
                                  }
                                }
                              },
                              //since this is only a UI app
                              child: isLoading != true
                                  ? Text(
                                      'Edit Profile',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                    ),
                              color: Color(0xffff2d55),
                              elevation: 0,
                              minWidth: 400,
                              height: 50,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
