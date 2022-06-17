import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  static const String columnUID = "uid";
  static const String columnName = "username";
  static const String columnEmail = "email";
  static const String columnUrl = "picture_url";

  User({
    required this.uid,
    required this.username,
    required this.email,
    required this.pictureUrl,
  });

  final String uid;
  final String username;
  final String email;
  final String pictureUrl;

  Map toMap() {
    Map<String, dynamic> map = {
      columnUID : uid,
      columnName : username,
      columnEmail : email,
      columnUrl : pictureUrl,
    };
    return map;
  }

  static User fromMap(Map map) {
    return User(
      uid: map[columnUID],
      username: map[columnName],
      email: map[columnEmail],
      pictureUrl: map[columnUrl],
    );
  }
}