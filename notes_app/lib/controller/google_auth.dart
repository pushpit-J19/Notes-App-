// for login with google
// keytool -list -v -alias androiddebugkey -keystore C:\Users\pushp\.android\debug.keystore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth auth = FirebaseAuth.instance;
CollectionReference users = FirebaseFirestore.instance.collection("users");

Future<bool> signInWithGoogle(BuildContext context) async {
  try {
    print("started loggin in");

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    print("111111111111111111111");

    if (googleSignInAccount != null) {
      print("inside iff");

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      print("22222222222222");

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      print("3333333333333333333333");

      // creating a firebase user after all authentication
      final UserCredential authResult =
          await auth.signInWithCredential(credential);
      print("444444444444444");

      final User user = authResult.user;
      print("5555555555555555");
      print(user);

      var userData = {
        'name': googleSignInAccount.displayName,
        'provider': 'google',
        'photoUrl': googleSignInAccount.photoUrl,
        'email': googleSignInAccount.email,
      };

      print(userData);

      // if exists from pehle se
      users.doc(user.uid).get().then((doc) => {
            if (doc.exists)
              {
                // user already there (old)
                print("user exists??????????????????????????????????"),
                doc.reference.update(userData)
/*
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => HomePage(),
                    ),
                );*/
              }
            else
              {
                // new user
                print("user does not exist??????????????????????????????????"),
                users.doc(user.uid).set(
                    userData) /*;

                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                ); */
              }
          });
    }
  } catch (PlatformException) {
    print(PlatformException);
    print("Unsuccessful signin !");
  }
}
