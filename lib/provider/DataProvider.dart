import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:post_request/model/Post.dart';
import 'package:post_request/api/api.dart';
import 'package:post_request/config.dart';
import 'package:cloudinary_client/cloudinary_client.dart';

class DataProvider with ChangeNotifier {

  bool _formPostingStatus = true;

  List<Post> _posts = [];

  String status = "";

  // cloudnary object
  CloudinaryClient client = new CloudinaryClient(variables['API_KEY'], variables['API_SECRET'], variables['CLOUD_NAME']);

  List<Post> get posts => _posts;

  bool get formPostingStatus => _formPostingStatus;

  set setFormStatus(bool status) {
    _formPostingStatus = status;
  }

  set _addPost(Post post) {

    _posts.add(post);

    notifyListeners();

  }

  Future<void> fetchPost() async {
    try {
      http.Response response = await http.get(api + 'posts');

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

  Future<String> addPost({@required title, @required description, @required imagePath}) async {

    String imageUrl = "";

    try {

    var response = await client.uploadImage(imagePath);

    imageUrl = response.url;

    } catch (e) {
      print(e);
    }

    Post post = Post(title: title, description: description, image: imageUrl);
    
    Map<String, dynamic> data = Post.toMap(post);

    final jsonData = json.encode(data);

    try {

      http.Response response = await http.post(api + 'posts', body: jsonData, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 201) {

        Map<String, dynamic> d = json.decode(response.body);

        final Post _post = Post.fromMap(d['post']);

        _addPost = _post; 

        status = "Post added";

      } else {
        
        print(response.body); // for debbuging response from the post api

        status = "Something went wrong";

      }
    } catch (e) {

      status = "Ops...Error Occured! \n Check your Internet Connection!";

      print("something went wrong");
      print(e);
    }

    return status;
  }


   Future<String> editPost({@required Post post}) async {

    Map<String, dynamic> data = Post.toMap(post);

    final jsonData = json.encode(data);

    try {

      http.Response response = await http.put(api + 'posts/${post.id}', body: jsonData, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 201) {

        Map<String, dynamic> d = json.decode(response.body);

        final Post _post = Post.fromMap(d['post']);

       int postIndex =  _posts.indexWhere((val)=> val.id == post.id);

       _posts[postIndex] = _post;

       status = "post edited successfully";

       notifyListeners();

      } else {
        
        print(response.body); // for debbuging response from the post api

        status = "Something went wrong";

      }
    } catch (e) {

      status = "Ops...Error Occured! \n Check your Internet Connection!";

      print("something went wrong");
      print(e);
    }

    return status;
  }

  Future<String> deletePost({@required Post post}) async {
    try {

      http.Response response = await http.delete(api + 'posts/${post.id}');

      if (response.statusCode == 200) {

        int postIndex = _posts.indexWhere((value) => value.id == post.id);

        _posts.removeAt(postIndex);

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

