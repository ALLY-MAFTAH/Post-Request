import 'package:flutter/material.dart';
import 'package:post_request/DataProvider.dart';
import 'package:provider/provider.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  FocusNode _titleFocusNode = FocusNode();
  FocusNode _descriptionFocusNode = FocusNode();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    var post = Provider.of<DataProvider>(context);
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
                    return "name is required";
                  else
                    return null;
                },
                decoration: InputDecoration(
                  hintText: "name",
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
                    return "description is required";
                  else
                    return null;
                },
                decoration: InputDecoration(
                  hintText: "description",
                ),
                keyboardType: TextInputType.text
              ),
            ),

            RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  post.addPost(
                    title: _titleController.text,
                    description: _descriptionController.text
                  ).then((value) {
                    if (value != "") {
                      showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => AlertDialog(
                        title: Text('Post Alert'),
                        content: Text('A new post is created'),
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
              child: Text('Add Post'),
            )
          ],
        )),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}