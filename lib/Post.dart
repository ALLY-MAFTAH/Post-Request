import 'package:flutter/foundation.dart';

class Post {
  int id;
  String title;
  String description;
  String image;

  Post({this.id, @required this.title, @required this.description, @required this.image});

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      image: map['imagePath']
    );
  }

  static Map<String, dynamic> toMap(Post post) {
    final Map<String, dynamic> data = <String, dynamic> {
      'title': post.title,
      'description': post.description,
      'image': post.image
    };

    return data;
  }
}