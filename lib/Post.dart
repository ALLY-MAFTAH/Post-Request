import 'package:flutter/foundation.dart';

class Post {
   String title;
   String description;

  Post({ @required this.title, @required this.description});

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      title: map['title'],
      description: map['description']
    );
  }

  static Map<String, dynamic> toMap(Post post) {
    final Map<String, dynamic> data = <String, dynamic> {
      'title': post.title,
      'description': post.description
    };

    return data;
  }
}