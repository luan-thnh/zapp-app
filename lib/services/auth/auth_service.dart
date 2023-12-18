import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:messenger/api/apis.dart';
import 'package:messenger/models/chat_user_model.dart';

class AuthService extends ChangeNotifier {
  // get current user
  User get user => APIs.firebaseAuth.currentUser!;

  // check user exists or not
  Future<bool> userExists() async {
    return (await APIs.fireStore.collection('users').doc(user.uid).get()).exists;
  }

  // sign in user with email and password
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await APIs.firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      // // add a new document for the user in users collection if it doesn't already exists
      ChatUserModel user = ChatUserModel.fromUserCredential(userCredential.user);

      APIs.fireStore.collection('users').doc(userCredential.user!.uid).set(user.toJson(), SetOptions(merge: true));

      return userCredential;
    }

    // catch any errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // create a new user by email and password
  Future<UserCredential> signUpWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await APIs.firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      // // after creating the user
      // APIs.fireStore.collection('users').doc(userCredential.user!.uid).set({'uid': userCredential.user!.uid, 'email': email});

      // if (context.mounted) {
      //   await sendEmailVerification(context);
      // }

      return userCredential;
    }

    // catch any errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // send email verification
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      APIs.firebaseAuth.currentUser!.sendEmailVerification();
    }

    // catch any errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

// sign in user with Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredential = await APIs.firebaseAuth.signInWithCredential(credential);

      ChatUserModel user = ChatUserModel.fromUserCredential(userCredential.user);

      APIs.fireStore.collection('users').doc(userCredential.user!.uid).set(user.toJson(), SetOptions(merge: true));

      return userCredential;
    }

    // catch any errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // sign out user
  Future<void> signOut() async {
    return await APIs.firebaseAuth.signOut();
  }
}
