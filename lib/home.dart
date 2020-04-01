import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:post_request/AddPost.dart';
import 'package:post_request/DataProvider.dart';
import 'package:post_request/Post.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Home extends StatelessWidget {

  final DataProvider dataProvider;

  Home({Key key, this.dataProvider}) : super(key: key);


  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);


  void _onRefresh() async {
    await dataProvider.fetchPost();

    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final dataObj = Provider.of<DataProvider>(context);

    List<Post> posts = dataObj.posts;

    return Scaffold(
        appBar: AppBar(
          title: Text('POST REQUEST APP'),
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
                child: ListView.separated(
                  itemBuilder: (context, int index) {
                    return _buildPostSection(
                      posts[index].image, 
                      posts[index].title, 
                      posts[index].description,
                    );
                  }, 
                  separatorBuilder: (context, int index) {
                    return Divider();
                  }, 
                  itemCount: posts.length),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            dataObj.setFormStatus = true;
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return AddPost();
              },),
            );
          },
          child: Icon(Icons.add),
        ),
      );
  }

  Widget _buildPostSection(String postImage, String title, String subtitle) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            margin: const EdgeInsets.only(right: 12),
            child: FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.cover,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: postImage,
                placeholder: (_, url) => CircularProgressIndicator(),
                errorWidget: (_, url, error) => Icon(Icons.error),
              ),
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                )
              ],
            )
          ),

          Icon(
            Icons.favorite_border,
            color: Colors.grey[500],
          ),
        ],
      ),
    );
  }
}
