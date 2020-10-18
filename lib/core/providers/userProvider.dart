import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:todolist/core/models/minUser.dart';
import 'package:todolist/core/utils/preferences.dart';

class UserProvider extends ChangeNotifier {
  MinUser _user;

  MinUser get user => _user;

  set user(MinUser value) {
    _user = value;
    notifyListeners();
  }

  static Future<String> autoLogin(BuildContext context) => Preferences.instance().then((value) async {
        try {
          final resp = await FirebaseFirestore.instance.collection("users").where("uid", isEqualTo: value.uid).get();
          print(resp.docs.first.data());
          UserProvider.instance(context).user = MinUser.fromJson(resp.docs.first.data());
          return null;
        } on FirebaseException catch (e) {
          return e.message;
        }
      });

  static Future<String> login(BuildContext context) async {
    try {
      GoogleSignInAccount account = await GoogleSignIn().signIn().then((value) => value).catchError((e) {
        print(e.toString());
      });
      if (account == null) return "Sign in aborted!";

      GoogleSignInAuthentication auth = await account.authentication;

      final userCredential = await FirebaseAuth.instance.signInWithCredential(GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      ));

      _saveUserInfo(context, userCredential);

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  static _saveUserInfo(BuildContext context, UserCredential credential) async {
    final collection = FirebaseFirestore.instance.collection("users");
    final qs = await collection.where("uid", isEqualTo: credential.user.uid).get();
    MinUser user = MinUser.fromJson(qs.docs.first.data());
    if (qs.size == 0) {
      await collection.add({
        "email": credential.user.email,
        "name": credential.user.displayName,
        "photo": credential.user.photoURL,
        "uid": credential.user.uid,
      });
    }

    Preferences.instance().then((value) {
      value.uid = user.uid;
    });
    UserProvider.instance(context).user = user;
  }

  static UserProvider instance(BuildContext context) => Provider.of<UserProvider>(context, listen: false);
}
