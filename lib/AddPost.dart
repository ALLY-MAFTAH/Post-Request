import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:post_request/DataProvider.dart';
import 'package:post_request/Post.dart';
import 'package:provider/provider.dart';

class AddPost extends StatefulWidget {
  final Post post;

  const AddPost({Key key, this.post}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {

  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });

    print('-----------------------------------');
    print(_image.path);
  }

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  FocusNode _titleFocusNode = FocusNode();
  FocusNode _descriptionFocusNode = FocusNode();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  bool _isButtonDisabled;

  @override
  void initState() {
    _isButtonDisabled = false;
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var postProvider = Provider.of<DataProvider>(context);
    
    if (!postProvider.formPostingStatus) {
      _titleController.text = widget.post.title;
      _descriptionController.text = widget.post.description;
    }


    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Add Post"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                focusNode: _titleFocusNode,
                controller: _titleController,
                validator: (val) {
                  if(val.isEmpty)
                    return "Title is required";
                  else
                    return null;
                },
                decoration: InputDecoration(
                  hintText: "Title",
                ),
                keyboardType: TextInputType.text
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                focusNode: _descriptionFocusNode,
                controller: _descriptionController,
                validator: (val) {
                  if(val.isEmpty)
                    return "Description is required";
                  else
                    return null;
                },
                decoration: InputDecoration(
                  hintText: "Description",
                ),
                keyboardType: TextInputType.text
              ),
            ),

            RaisedButton(
              onPressed: _isButtonDisabled ? null : () {

                if (_formKey.currentState.validate() && !_isButtonDisabled) {

                  setState(() {
                  _isButtonDisabled = true;
                });

                  postProvider.formPostingStatus ?

                  postProvider.addPost(
                    title: _titleController.text,
                    description: _descriptionController.text, imagePath: _image.path,
                  ).then((value) {
                    if (value != "") {
                      showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => AlertDialog(
                        title: Text('Post Alert'),
                        content: Text(postProvider.status),
                        actions: <Widget>[
                          FlatButton(onPressed: () {
                            Navigator.of(context).pop();
                          }, child: Text('Ok'))
                        ],
                        elevation: 24.0,
                      )
                    ).then((_) {
                      _titleController.clear();
                      _descriptionController.clear();
                      Navigator.of(context).pop();
                    });

                    
                    }
                  }) :

                  postProvider.editPost(
                   post: Post(title: _titleController.text, description: _descriptionController.text, id: widget.post.id, image: widget.post.image)
                  ).then((value) {
                    if (value != "") {
                      showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => AlertDialog(
                        title: Text('Post Alert'),
                        content: Text(postProvider.status),
                        actions: <Widget>[
                          FlatButton(onPressed: () {
                            Navigator.of(context).pop();
                          }, child: Text('Ok'))
                        ],
                        elevation: 24.0,
                      )
                    ).then((_) {
                      Navigator.of(context).pop();
                    });

                    _titleController.text = "";
                    _descriptionController.text = "";
                    }
                  });
                }

              },
              child: Text(
                _isButtonDisabled ? 'Hold on...' : postProvider.formPostingStatus ? 'Add Post' : 'Edit Post'),
            ),

            Container(
              height: 200,
              child: _image == null ? Text('No image selected') : Image.file(_image),
            )
          ],
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: getImage,
          child: Icon(Icons.photo),
        )
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}