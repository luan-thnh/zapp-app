import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:messenger/api/apis.dart';
import 'package:messenger/constants/image_urls.dart';
import 'package:messenger/models/chat_user_model.dart';
import 'package:messenger/models/friend_request_model.dart';

class AuthService extends ChangeNotifier {
  // get current user
  User get user => APIs.firebaseAuth.currentUser!;

  // check user exists or not
  Future<bool> userExists() async {
    return (await APIs.fireStore.collection('users').doc(user.uid).get()).exists;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> findAllUsers() {
    return APIs.fireStore.collection('users').where('id', isNotEqualTo: user.uid).snapshots();
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
  Future<UserCredential> signUpWithEmailAndPassword(String email, String password) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      UserCredential userCredential = await APIs.firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      // // after creating the user
      // APIs.fireStore.collection('users').doc(userCredential.user!.uid).set({'uid': userCredential.user!.uid, 'email': email});

      // if (context.mounted) {
      //   await sendEmailVerification(context);
      // }

      final chatUserModel = ChatUserModel(
          id: user.uid,
          username: email,
          firstName: '',
          lastName: '',
          dayOfBirth: '',
          gender: '',
          email: email,
          avatar: ImageUrls.avatarDefault,
          description: 'Hey, I"m using Zapp!!',
          isOnline: false,
          token: '',
          lastActive: time,
          createdAt: time,
          updatedAt: time);

      await APIs.fireStore.collection('users').doc(user.uid).set(chatUserModel.toJson());

      return userCredential;
    }

    // catch any errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> createUserEmail(myUser) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUserModel = ChatUserModel(
        id: user.uid,
        username: '',
        firstName: '',
        lastName: '',
        dayOfBirth: '',
        gender: '',
        email: myUser.toString(),
        avatar: ImageUrls.avatarDefault,
        description: 'Hey, I"m using Zapp!!',
        isOnline: false,
        token: '',
        lastActive: time,
        createdAt: time,
        updatedAt: time);

    return await APIs.fireStore.collection('users').doc(user.uid).set(chatUserModel.toJson());
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

  // sign in user with Google
  Future<UserCredential> signInWithFacebook() async {
    try {
      // Trigger the authentication flow
      final LoginResult facebookUser = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final OAuthCredential credential = FacebookAuthProvider.credential(facebookUser.accessToken!.token);

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
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
    return await APIs.firebaseAuth.signOut();
  }

  Future<void> updateUserInfo(String firstName, String lastName, String birthday, String gender) async {
    await APIs.fireStore.collection('users').doc(user.uid).update({
      'username': firstName + ' ' + lastName,
      'first_name': firstName,
      'last_name': lastName,
      'birthday': birthday,
      'gender': gender,
    });
  }

  //update profile picture of user
  Future<void> updateProfilePicture(File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = APIs.storage.ref().child('images/${user.uid}.$ext');

    //uploading image
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firebase database
    String avatar = await ref.getDownloadURL();
    await APIs.fireStore.collection('users').doc(user.uid).update({'avatar': avatar});

    Future<List<FriendRequestModel>> fetchFriendRequests() async {
      // Fetch friend requests from Firestore
      QuerySnapshot querySnapshot = await APIs.fireStore.collection('friendRequests').get();

      List<FriendRequestModel> friendRequests = [];

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        friendRequests.add(FriendRequestModel(
          senderName: document['senderName'],
        ));
      }

      return friendRequests;
    }

    Future<void> acceptFriendRequest(FriendRequestModel friendRequest) async {
      // Add the friend to the user's friend list
      // (You may need to adapt this based on your data structure)
      await APIs.fireStore.collection('users').doc('currentUserId').collection('friends').add({'friendName': friendRequest.senderName});

      // Delete the friend request
      await APIs.fireStore.collection('friendRequests').where('senderName', isEqualTo: friendRequest.senderName).get().then((snapshot) {
        for (QueryDocumentSnapshot document in snapshot.docs) {
          document.reference.delete();
        }
      });
    }
  }
}
