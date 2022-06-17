import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  static const String columnUID = "uid";
  static const String columnName = "username";
  static const String columnEmail = "email";
  static const String columnTitle = "title";
  static const String columnContent = "content";
  static const String columnImage = "image";
  static const String columnTime = "date";
  static const String columnUrl = "file_url";

  Post({
    required this.uid,
    required this.username,
    required this.email,
    required this.title,
    required this.content,
    required this.image,
    required this.time,
    required this.fileUrl,
  });

  final String uid;
  final String username;
  final String email;
  final String title;
  final String content;
  final String image;
  final Timestamp time;
  final String fileUrl;

  Map toMap() {
    Map<String, dynamic> map = {
      columnUID : uid,
      columnName : username,
      columnEmail : email,
      columnTitle : title,
      columnContent : content,
      columnImage : image,
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
      image: map[columnImage],
      time: map[columnTime],
      fileUrl: map[columnUrl],
    );
  }
}