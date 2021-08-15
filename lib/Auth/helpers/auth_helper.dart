import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gsg2_firebase/services/custom_dialoug.dart';
import 'package:gsg2_firebase/services/routes_helper.dart';

class AuthHelper {
  AuthHelper._();
  static AuthHelper authHelper = AuthHelper._();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  signup(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        CustomDialoug.customDialoug
            .showCustomDialoug('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        CustomDialoug.customDialoug
            .showCustomDialoug('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  signin(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        CustomDialoug.customDialoug
            .showCustomDialoug('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        CustomDialoug.customDialoug
            .showCustomDialoug('Wrong password provided for that user.');
      }
    }
  }

  resetPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
    CustomDialoug.customDialoug.showCustomDialoug(
        'we have sent email for reset password, please check your email');
  }

  verifyEmail() async {
    await firebaseAuth.currentUser.sendEmailVerification();
    CustomDialoug.customDialoug.showCustomDialoug(
        'verification email has been sent, please check your email');
  }

  logout() async {
    firebaseAuth.signOut();
  }

  bool checkEmailVerification() {
    return firebaseAuth.currentUser?.emailVerified ?? false;
  }
}
