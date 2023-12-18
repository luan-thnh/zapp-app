import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:messenger/api/apis.dart';
import 'package:messenger/constants/image_urls.dart';
import 'package:messenger/models/chat_user_model.dart';
import 'package:messenger/models/friend_request_model.dart';
import 'package:messenger/models/message_model.dart';

class AuthService extends ChangeNotifier {
  // get info user
  late ChatUserModel me;

  User get user => APIs.firebaseAuth.currentUser!;

  // check user exists or not
  Future<bool> userExists() async {
    return (await APIs.fireStore.collection('users').doc(user.uid).get()).exists;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> findAllUsers() {
    return APIs.fireStore.collection('users').where('id', isNotEqualTo: user.uid).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return APIs.fireStore.collection('users').doc(user.uid).collection('friends').snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getResquestFriendId() {
    return APIs.fireStore.collection('users').doc(user.uid).collection('resquestFriend').snapshots();
  }

  Future<void> acceptFriendRequest(String id, bool isDelete) async {
    if (isDelete) {
      await APIs.fireStore.collection('users').doc(id).collection('resquestFriend').doc(user.uid).delete();
    } else {
      await APIs.fireStore.collection('users').doc(id).collection('resquestFriend').doc(user.uid).set({});
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(List<String> userIds) {
    log('\nUserIds: $userIds');

    return APIs.fireStore
        .collection('users')
        .where('id', whereIn: userIds.isEmpty ? [''] : userIds) //because empty list throws an error
        // .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getSuggestUsers(List<String> userIds, String uid) {
    log('\nUserIds: $userIds');

    return APIs.fireStore
        .collection('users')
        .where('id', whereNotIn: userIds.isEmpty ? [''] : [...userIds, uid]) //because empty list throws an error
        // .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  Future<bool> unFriend(String id) async {
    if (id.isNotEmpty) {
      await APIs.fireStore.collection('users').doc(user.uid).collection('friends').doc(id).delete();
      await APIs.fireStore.collection('users').doc(id).collection('friends').doc(user.uid).delete();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteChatUser(String id) async {
    if (id.isNotEmpty) {
      await APIs.fireStore.collection('users').doc(user.uid).collection('resquestFriend').doc(id).delete();
      return true;
    } else {
      return false;
    }
  }

  // for adding an chat user for our conversation
  Future<bool> addChatUser(String id) async {
    final data = await APIs.fireStore.collection('users').where('id', isEqualTo: id).get();

    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      //user exists

      APIs.fireStore.collection('users').doc(user.uid).collection('friends').doc(data.docs.first.id).set({});
      APIs.fireStore.collection('users').doc(id).collection('friends').doc(user.uid).set({});
      APIs.fireStore.collection('users').doc(user.uid).collection('resquestFriend').doc(id).delete();
      return true;
    } else {
      // user doesn't exists

      return false;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> findUsersOnline() {
    return APIs.fireStore.collection('users').where('id', isNotEqualTo: user.uid).where('isOnline', isEqualTo: true).snapshots();
  }

  Future<ChatUserModel> findUserById(String userId) async {
    try {
      final userSnapshot = await APIs.fireStore.collection('users').doc(userId).get();

      ChatUserModel user = ChatUserModel.fromJson(userSnapshot.data() ?? {});

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
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
        isOnline: true,
        token: '',
        lastActive: time,
        createdAt: time,
        updatedAt: time,
      );

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
        isOnline: true,
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
      'username': '$firstName $lastName',
      'first_name': firstName,
      'last_name': lastName,
      'birthday': birthday,
      'gender': gender,
    });
  }

  Future<void> updateDarkMode(bool isDark) async {
    await APIs.fireStore.collection('users').doc(user.uid).update({'is_dark': isDark});
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
      await APIs.fireStore.collection('users').doc('currentUserId').collection('friends').add({'friendName': friendRequest.senderName});

      // Delete the friend request
      await APIs.fireStore.collection('friendRequests').where('senderName', isEqualTo: friendRequest.senderName).get().then((snapshot) {
        for (QueryDocumentSnapshot document in snapshot.docs) {
          document.reference.delete();
        }
      });
    }
  }

  // API: Messages

  String getCoversation(String id) => user.uid.hashCode <= id.hashCode ? '${user.uid}_$id' : '${id}_${user.uid}';

  Stream<QuerySnapshot<Map<String, dynamic>>> findAllMessages(ChatUserModel user) {
    return APIs.fireStore.collection('chats/${getCoversation(user.id)}/messages').orderBy('sent', descending: true).snapshots();
  }

  // Sending message
  Future<void> sendMessage(ChatUserModel chatUser, String msg, Type type, String? duration) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final MessageModel message = MessageModel(
      read: '',
      type: type,
      message: msg,
      sent: time,
      toId: chatUser.id,
      fromId: user.uid,
      duration: type == Type.audio ? duration as String : '${Duration.zero}',
    );

    final ref = APIs.fireStore.collection('chats/${getCoversation(chatUser.id)}/messages');
    await ref.doc(time).set(message.toJson()).then((value) {
      String getMessageText() {
        if (type == Type.image) {
          return 'Sent one photo';
        } else if (type == Type.audio) {
          return 'Sent one voice message sent';
        } else {
          return msg;
        }
      }

      sendPushNotification(chatUser, getMessageText());
    });
  }

  // Update status
  Future<void> updateMessageReadStatus(MessageModel message) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    APIs.fireStore.collection('chats/${getCoversation(message.fromId)}/messages').doc(message.sent).update({'read': time});
  }

  // check user exists or not
  Future<bool> messageExists(ChatUserModel chatUser) async {
    final querySnapshot = await APIs.fireStore.collection('chats/${getCoversation(chatUser.id)}/messages').get();
    return querySnapshot.docs.isNotEmpty;
  }

  // get last message
  Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(ChatUserModel user) {
    return APIs.fireStore.collection('chats/${getCoversation(user.id)}/messages').orderBy('sent', descending: true).limit(1).snapshots();
  }

  // get last read message from user id
  Stream<QuerySnapshot<Map<String, dynamic>>> getLastReadMessage(ChatUserModel toUser) {
    return APIs.fireStore.collection('chats/${getCoversation(toUser.id)}/messages').where('fromId', isEqualTo: user.uid).snapshots();
  }

  // send chat image
  Future<void> sendChatImage(ChatUserModel chatUser, File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;
    DateTime now = DateTime.now();
    String formattedDate = '${now.millisecondsSinceEpoch.toString()}-${now.day}-${now.month}-${now.year}-${user.uid}';

    //storage file ref with path
    final ref = APIs.storage.ref().child('images/chats/${getCoversation(chatUser.id)}/$formattedDate.$ext');

    //uploading image
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firebase database
    String imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image, null);
  }

  // send audio message
  Future<void> sendAudioMessage(ChatUserModel chatUser, String audioFilePath, Duration duration) async {
    // getting audio file extension
    final ext = audioFilePath.split('.').last;
    DateTime now = DateTime.now();
    String formattedDate = '${now.millisecondsSinceEpoch.toString()}-${now.day}-${now.month}-${now.year}-${user.uid}';

    // storage file ref with path
    final ref = APIs.storage.ref().child('audio/chats/${getCoversation(chatUser.id)}/$formattedDate.$ext');

    // uploading audio
    await ref.putFile(File(audioFilePath), SettableMetadata(contentType: 'audio/$ext')).then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    // updating audio in Firebase database
    String audioUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, audioUrl, Type.audio, duration.toString());
  }

  // get user info
  Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(ChatUserModel chatUser) {
    return APIs.fireStore.collection('users').where('id', isEqualTo: chatUser.id).snapshots();
  }

  // get user info
  Future<void> updateActiveStatus(bool isOnline) async {
    APIs.fireStore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'token': me.token,
    });
  }

  Future<void> getSelfInfo() async {
    await APIs.fireStore.collection('users').doc(user.uid).get().then(
      (user) async {
        if (user.exists) {
          me = ChatUserModel.fromJson(user.data()!);

          await getFirebaseMessagingToken();
          updateActiveStatus(true);
        }
      },
    );
  }

  Future<void> sendPushNotification(ChatUserModel user, String msg) async {
    try {
      final body = {
        "to": user.token,
        "notification": {"title": "${user.firstName} ${user.lastName}", "body": msg}
      };

      var response = await post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'key=AAAADjTvmyY:APA91bHj3GHjTyQpQ6byMlmlvh7hrhwWsbtd3MglDrfjyHAgSovxVWKlZsXjLgoB1T42PcaOB_uw3bDlSUrXJcDMBMSodfmpvuQWSA9VYR6Ax7GTgR9V-8gY5d85GtLIA9tAPDEyOwsg',
        },
        body: jsonEncode(body),
      );

      print('REQUEST BODY: ${response.body}');
    } catch (e) {
      print('SEND MESSAGE ERROR: $e');
    }
  }

  Future<void> getFirebaseMessagingToken() async {
    await APIs.fireMessaging.requestPermission();
    await APIs.fireMessaging.getToken().then((t) {
      if (t != null) {
        me.token = t;
      }
    });
  }
}
