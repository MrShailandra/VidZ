import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class firebaseServices {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  var uid = FirebaseAuth.instance.currentUser;
  var result;
  final databaseReference = FirebaseDatabase.instance.reference();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DateTime now = DateTime.now();
  CollectionReference users = FirebaseFirestore.instance.collection('meetings');



  Future<void> addMeetingInFirebase(subject, id, email) {
    var time = now.hour.toString() +
        ":" +
        now.minute.toString() +
        ":" +
        now.second.toString();

    // Call the user's CollectionReference to add a new user
    return users
        .add({'Subject': subject, 'ID': id, 'time': time, 'email': email})
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  //Email-Password Login
  emailLogin(email, password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user.uid != null) {
        return userCredential.user;
      } else {
        print("Something Went Wrong");
        return null;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return null;
      } else if (e.code == 'wrong-password') {
        return null;
      }
    }
  }
updateUser(name,number){
  if (FirebaseAuth.instance.currentUser.uid  != null) {
    databaseReference.child(FirebaseAuth.instance.currentUser.uid).update({
      'name': name,
      'number': number
    });
    return FirebaseAuth.instance.currentUser.uid;
  } else {
    print("Something Went Wrong");
    return null;
  }
}
  //Email Password Registation

  emailRegister(email, password, name, number) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user.uid != null) {
        databaseReference.child(userCredential.user.uid).set({
          'name': name,
          'password': password,
          'email': email,
          'number': number
        });
        return userCredential.user;
      } else {
        print("Something Went Wrong");
        return null;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return null;
      }
    } catch (e) {
      print(e);
    }
  }
}
