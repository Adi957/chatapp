//This is used for making an object for keeping our data
//import 'dart:js_interop';
class ChatUser {
  ChatUser({
    required this.image,
    required this.id,
    required this.about,
    required this.name,
    required this.createdAt,
    required this.isOnline,
    required this.lastActive,
    required this.email,
    required this.pushToken,
  });
  late String image;
  late String id;
  late String about;
  late String name;
  late String createdAt;
  late bool isOnline;
  late String lastActive;
  late String email;
  late String pushToken;

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    id = json['id '] ?? '';
    about = json['about'] ?? '';
    name = json['name'] ?? '';
    createdAt = json['created_at'] ?? '';
    isOnline = json['is_online'] ?? '';
    lastActive = json['last_active'] ?? false;
    email = json['email'] ?? '';
    pushToken = json['push_token'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['image'] = image;
    _data['id '] = id;
    _data['about'] = about;
    _data['name'] = name;
    _data['created_at'] = createdAt;
    _data['is_online'] = isOnline;
    _data['last_active'] = lastActive;
    _data['email'] = email;
    _data['push_token'] = pushToken;
    return _data;
  }
}
