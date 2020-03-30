import 'package:flutter/material.dart';
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

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  FocusNode _usernameFocusNode = FocusNode();
  FocusNode _captionFocusNode = FocusNode();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _captionController = TextEditingController();

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
      _usernameController.text = widget.post.username;
      _captionController.text = widget.post.caption;
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
                focusNode: _usernameFocusNode,
                controller: _usernameController,
                validator: (val) {
                  if(val.isEmpty)
                    return "Username is required";
                  else
                    return null;
                },
                decoration: InputDecoration(
                  hintText: "Username",
                ),
                keyboardType: TextInputType.text
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                focusNode: _captionFocusNode,
                controller: _captionController,
                validator: (val) {
                  if(val.isEmpty)
                    return "Caption is required";
                  else
                    return null;
                },
                decoration: InputDecoration(
                  hintText: "Caption",
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
                    username: _usernameController.text,
                    caption: _captionController.text,
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
                      _usernameController.clear();
                      _captionController.clear();
                      Navigator.of(context).pop();
                    });

                    
                    }
                  }) :

                  postProvider.editPost(
                   post: Post(username: _usernameController.text, caption: _captionController.text, id: widget.post.id)
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

                    _usernameController.text = "";
                    _captionController.text = "";
                    }
                  });
                }

              },
              child: Text(
                _isButtonDisabled ? 'Hold on...' : postProvider.formPostingStatus ? 'Add Post' : 'Edit Post'),
            )
          ],
        )),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _captionController.dispose();
    super.dispose();
  }
}