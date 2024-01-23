import 'package:firebase_auth/firebase_auth.dart';

class ChatUserModel {
  ChatUserModel({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.dayOfBirth,
    required this.gender,
    required this.email,
    required this.avatar,
    required this.description,
    required this.isOnline,
    required this.token,
    required this.lastActive,
    required this.createdAt,
    required this.updatedAt,
  });

  late final String id;
  late final String username;
  late final String firstName;
  late final String lastName;
  late final String dayOfBirth;
  late final String gender;
  late final String email;
  late final String avatar;
  late final String description;
  late final bool isOnline;
  late String token;
  late final String lastActive;
  late final String createdAt;
  late final String updatedAt;

  ChatUserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    username = json['username'] ?? '';
    firstName = json['first_name'] ?? '';
    lastName = json['last_name'] ?? '';
    dayOfBirth = json['day_of_birth'] ?? '';
    gender = json['gender'] ?? '';
    email = json['email'] ?? '';
    avatar = json['avatar'] ?? '';
    description = json['description'] ?? '';
    isOnline = json['is_online'] ?? false;
    token = json['token'] ?? '';
    lastActive = json['last_active'] ?? '';
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
  }

  factory ChatUserModel.fromUserCredential(User? user) {
    final time = DateTime.now().microsecondsSinceEpoch.toString();
    List<String> nameParts = user!.displayName!.split(' ');
    String firstName = nameParts[0];
    String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    return ChatUserModel(
      id: user.uid,
      username: 'zapp-01',
      firstName: firstName,
      lastName: lastName,
      dayOfBirth: '',
      gender: '',
      email: user.email.toString(),
      avatar: user.photoURL.toString(),
      description: "Hey, I'm using Zapp!",
      isOnline: false,
      token: '',
      lastActive: time,
      createdAt: time,
      updatedAt: time,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['day_of_birth'] = dayOfBirth;
    data['gender'] = gender;
    data['email'] = email;
    data['avatar'] = avatar;
    data['description'] = description;
    data['is_online'] = isOnline;
    data['token'] = token;
    data['last_active'] = lastActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
