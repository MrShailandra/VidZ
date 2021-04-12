import 'dart:async';
import 'dart:io';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vidg/Screens/Dashboard.dart';
import 'LoginPage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoginValue = false;

  StreamSubscription<DataConnectionStatus> listener;
  var InternetStatus = "Unknown";
  var contentmessage = "Unknown";

  checkConnection(BuildContext context) async {
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          break;
        case DataConnectionStatus.disconnected:
          _scaffoldKey.currentState.showSnackBar(new SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text("Please Check Internet Connection...")));
          break;
      }
    });
    return await DataConnectionChecker().connectionStatus;
  }

  void isLogin() async {
    if (FirebaseAuth.instance.currentUser == null) {
      setState(() {
        isLoginValue = false;
      });
    } else {
      setState(() {
        isLoginValue = true;
      });
    }
  }

  @override
  void initState() {
    checkConnection(context);
    isLogin();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    isLoginValue ? DashBoard() : LoginPage())));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          "assets/logo.png",
          height: 100,
          width: 100,
        ),
      ),
    );
  }
}
