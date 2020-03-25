import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:post_request/Post.dart';

class DataProvider with ChangeNotifier {

  final String url = "http://192.168.43.119:8000/api/posts";

  List<Post> _posts = [];

  String status = "";

  List<Post> get posts => _posts;

  set _addPost(Post post) {
    _posts.add(post);

    notifyListeners();

  }

  Future<void> fetchPost() async {
    try {
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {

        _posts = [];

        Map<String, dynamic> data = json.decode(response.body);

        data['posts'].forEach((post) {
          final Post _post = Post.fromMap(post);
          _posts.add(_post);
        });
      }
      
    } catch (e) {

      status = "Ops...an error occured! \n Check your Internet Connection!";

      print("Something went wrong");
      print(e);
    }

    notifyListeners();
  }

  Future<String> addPost({title, description}) async {

    final Post post = Post(title: title, description: description);

    _addPost = post;

    Map<String, dynamic> data = Post.toMap(post);
    final jsonData = json.encode(data);

    try {
      http.Response response = await http.post(url, body: jsonData, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 201) {

        status = "post added";

      } else {
        
        print(response.body); // for debbuging response from the post api

        status = "Something went wrong";

        print(_posts.removeLast());
      }
    } catch (e) {

      status = "Ops...Error Occured! \n Check your Internet Connection!";

      print("something went wrong");
      print(e);
    }

    return status;
  }

  Future<String> deletePost({@required Post post, @required int index}) async {
    try {

      _posts.removeAt(index);

      http.Response response = await http.delete(url + '/${post.id}');

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        status = data['message'];
      } else {

        Map<String, dynamic> data = json.decode(response.body);

        status = data['message'];
      }
    } catch(e) {

      print("something went wrong");

      print(e);
    }

    notifyListeners();
    
    return status;
  }
}

