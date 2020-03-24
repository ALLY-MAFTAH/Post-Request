import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:post_request/Post.dart';

class DataProvider extends ChangeNotifier {
  final String url = "http://192.168.1.13:8000/api/posts";
  final List<Post> _posts = [];

  List<Post> get posts => [..._posts];

  Future<void> fetchPost() async {
    try {
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        data['posts'].forEach((post) {
          final Post _post = Post.fromMap(post);
          _posts.add(_post);
        });
      }
      
    } catch (e) {
      print("Something went wrong");
      print(e);
    }

    notifyListeners();
  }

  Future<String> addPost({title, description}) async {
    String status = "";

    final Post post = Post();
    post.title = title;
    post.description = description;
    
    Map<String, dynamic> data = Post.toMap(post);
    final jsonData = json.encode(data);

    try {
      http.Response response = await http.post(url, body: jsonData, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        status = "post added";
      } else {

        print(response.body); // for debbuging response from the post api

        status = "Something went wrong";
      }
    } catch (e) {
      print("something went wrong");
      print(e);
    }

    return status;
  }
}

