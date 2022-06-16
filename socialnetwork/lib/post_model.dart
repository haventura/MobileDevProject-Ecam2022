import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  static const String columnName = "username";
  static const String columnEmail = "email";
  static const String columnTitle = "title";
  static const String columnContent = "content";
  static const String columnImage = "image";
  static const String columnTime = "date";

  Post({
    required this.username,
    required this.email,
    required this.title,
    required this.content,
    required this.image,
    required this.time,
  });

  final String username;
  final String email;
  final String title;
  final String content;
  final String image;
  final Timestamp time;

  Map toMap() {
    Map<String, dynamic> map = {
      columnName : username,
      columnEmail : email,
      columnTitle : title,
      columnContent : content,
      columnImage : image,
      columnTime : time,
    };
    return map;
  }

  static Post fromMap(Map map) {
    return Post(
      username: map[columnName],
      email: map[columnEmail],
      title: map[columnTitle],
      content: map[columnContent],
      image: map[columnImage],
      time: map[columnTime]
    );
  }
}