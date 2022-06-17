import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  static const String columnUID = "uid";
  static const String columnName = "username";
  static const String columnEmail = "email";
  static const String columnTitle = "title";
  static const String columnContent = "content";
  static const String columnTime = "date";
  static const String columnUrl = "file_url";

  Post({
    required this.uid,
    required this.username,
    required this.email,
    required this.title,
    required this.content,
    required this.time,
    required this.fileUrl,
  });

  final String uid;
  final String username;
  final String email;
  final String title;
  final String content;
  final Timestamp time;
  final String fileUrl;

  Map toMap() {
    Map<String, dynamic> map = {
      columnUID : uid,
      columnName : username,
      columnEmail : email,
      columnTitle : title,
      columnContent : content,
      columnTime : time,
      columnUrl : fileUrl,
    };
    return map;
  }

  static Post fromMap(Map map) {
    return Post(
      uid: map[columnUID],
      username: map[columnName],
      email: map[columnEmail],
      title: map[columnTitle],
      content: map[columnContent],
      time: map[columnTime],
      fileUrl: map[columnUrl],
    );
  }
}