import 'package:firebase_auth/firebase_auth.dart';

class ChatUserModel {
  ChatUserModel({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
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
  late final String email;
  late final String avatar;
  late final String description;
  late final bool isOnline;
  late final String token;
  late final String lastActive;
  late final String createdAt;
  late final String updatedAt;

  ChatUserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    username = json['username'] ?? '';
    firstName = json['first_name'] ?? '';
    lastName = json['last_name'] ?? '';
    email = json['email'] ?? '';
    avatar = json['avatar'] ?? '';
    description = json['description'] ?? '';
    isOnline = json['is_online'] ?? '';
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
      email: user.email.toString(),
      avatar: user.photoURL.toString(),
      description: 'Hello, My name is ABC',
      isOnline: true,
      token: '',
      lastActive: time,
      createdAt: time,
      updatedAt: time,
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['username'] = username;
    _data['first_name'] = firstName;
    _data['last_name'] = lastName;
    _data['email'] = email;
    _data['avatar'] = avatar;
    _data['description'] = description;
    _data['is_online'] = isOnline;
    _data['token'] = token;
    _data['last_active'] = lastActive;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}