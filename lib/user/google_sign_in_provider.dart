import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: '937469130987-f4lu896haufafc5nhb8v1abijhjeoijk.apps.googleusercontent.com',
  );

  Future<User?> signInWithGoogle() async {
    try {
      print("Starting Google Sign-In...");
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        print("Google Sign-In canceled by user.");
        return null;
      }

      print("Getting authentication tokens...");
      final googleAuth = await googleUser.authentication;

      print("Creating credential...");
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print("Signing in to Firebase...");
      final userCredential = await _auth.signInWithCredential(credential);

      print("Sign-in successful!");
      return userCredential.user;
    } catch (e, stacktrace) {
      print('Google sign-in error caught: $e');
      print(stacktrace);
      Fluttertoast.showToast(
        msg: 'Sign-in failed. Please try again.',
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
      rethrow; // let caller handle error if needed
    }
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    await _auth.signOut();
  }
}
