import 'package:flutter/foundation.dart';

class Post {
  int id;
  String username;
  String caption;

  Post({this.id, @required this.username, @required this.caption});

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      username: map['title'],
      caption: map['description']
    );
  }

  static Map<String, dynamic> toMap(Post post) {
    final Map<String, dynamic> data = <String, dynamic> {
      'title': post.username,
      'description': post.caption
    };

    return data;
  }
}