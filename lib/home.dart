import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:post_request/AddPost.dart';
import 'package:post_request/DataProvider.dart';
import 'package:post_request/Post.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Home extends StatefulWidget {
  final DataProvider dataProvider;

  Home({Key key, @required this.dataProvider}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isLiked = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await widget.dataProvider.fetchPost();

    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final dataObj = Provider.of<DataProvider>(context);

    List<Post> posts = dataObj.posts;

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/back.PNG"), fit: BoxFit.cover)),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.lime[300].withOpacity(0.3),
        appBar: AppBar(
          centerTitle: true,
          title: Text('POST REQUEST APP',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )),
        ),
        body: posts.isEmpty
            ? Center(
                child: dataObj.status != ""
                    ? Text(
                        'No available Post',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      )
                    : CircularProgressIndicator())
            : SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                header: WaterDropHeader(),
                footer: CustomFooter(builder: (context, LoadStatus mode) {
                  Widget body;
                  if (mode == LoadStatus.idle) {
                    body = Text('pull down load');
                  } else if (mode == LoadStatus.loading) {
                    body = CupertinoActivityIndicator();
                  } else if (mode == LoadStatus.failed) {
                    body = Text("Load Failed!Click retry!");
                  } else {
                    body = Text("No more Data");
                  }

                  return Container(
                    child: Center(child: body),
                  );
                }),
                onRefresh: _onRefresh,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.ac_unit,
                            color: Colors.blue[800],
                          ),
                          Text(
                            " Current Available Posts",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 20),
                          Text(
                            "(" + posts.length.toString() + ")",
                            style: TextStyle(
                                color: Colors.deepPurple[900],
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    Expanded(
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            return Card(
                              key: GlobalKey(),
                              elevation: 5,
                              color: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                topRight: Radius.circular(50),
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(50),
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                      color: Colors.white.withOpacity(0.3)),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: InkWell(
                                              child: Container(
                                                height: 250,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    4 /
                                                    5,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/images/qlicue.jpg"),
                                                        fit: BoxFit.cover)),
                                              ),
                                              onDoubleTap: () {
                                                setState(() {
                                                  _isLiked = !_isLiked;
                                                });
                                              },
                                            ),
                                          ),
                                          Container(
                                            child: Column(
                                              children: <Widget>[
                                                _isLiked
                                                    ? IconButton(
                                                        icon: Icon(
                                                            Icons.favorite),
                                                        iconSize: 38,
                                                        color:
                                                            Colors.red,
                                                        onPressed: () {
                                                          setState(() {
                                                            _isLiked =
                                                                !_isLiked;
                                                          });
                                                        })
                                                    : IconButton(
                                                        icon: Icon(
                                                            Icons.favorite),
                                                        color: Colors.grey[600],
                                                        iconSize: 38,
                                                        onPressed: () {
                                                          setState(() {
                                                            _isLiked =
                                                                !_isLiked;
                                                          });
                                                        }),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      12,
                                                ),
                                                IconButton(
                                                    icon: Icon(Icons.edit),
                                                    color: Colors.blueAccent,
                                                    onPressed: () {
                                                      dataObj.setFormStatus =
                                                          false;

                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return AddPost(
                                                          post: posts[index],
                                                        );
                                                      }));
                                                    }),
                                                IconButton(
                                                    icon: Icon(Icons.delete),
                                                    color: Colors.redAccent,
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (_) =>
                                                            AlertDialog(
                                                          title: Text('Post'),
                                                          content: Text(
                                                              "Are you sure you want to delete this post?"),
                                                          actions: <Widget>[
                                                            FlatButton(
                                                                child:
                                                                    Text('YES'),
                                                                onPressed: () {
                                                                  dataObj
                                                                      .deletePost(
                                                                          post: posts[
                                                                              index])
                                                                      .then(
                                                                          (value) {
                                                                    _scaffoldKey
                                                                        .currentState
                                                                        .showSnackBar(SnackBar(
                                                                            content:
                                                                                Text("Post deleted successfull")));
                                                                  });
                                                                  Navigator.pop(
                                                                      context);
                                                                })
                                                          ],
                                                        ),
                                                      );
                                                    })
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: RichText(
                                            text: TextSpan(
                                                text: "@" +
                                                    posts[index].username +
                                                    ": ",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FontStyle.italic),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text:
                                                          posts[index].caption,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontStyle:
                                                              FontStyle.normal))
                                                ]),
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            );
                          }),
                    ),
                  ],
                ),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          elevation: 10,
          onPressed: () {
            dataObj.setFormStatus = true;
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return AddPost();
            }));
          },
          child: Icon(Icons.add),
        ),
        bottomNavigationBar: BottomAppBar(elevation: 0,
          notchMargin: 8,
          // color: Colors.lime[300].withOpacity(0.2),
          shape: CircularNotchedRectangle(),
          child: Container(
            color: Colors.lime[500].withOpacity(0.4),
            height: 35,
          ),
        ),
      ),
    );
  }
}
