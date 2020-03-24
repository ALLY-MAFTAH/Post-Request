import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:post_request/AddPost.dart';
import 'package:post_request/DataProvider.dart';
import 'package:post_request/Post.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final DataProvider _dataProvider = DataProvider();

  @override
  void initState() {
    _dataProvider.fetchPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _dataProvider,
      child: MaterialApp(
      home: Home(dataProvider: _dataProvider,),
    ),
    );
  }
}



class Home extends StatelessWidget {

  final DataProvider dataProvider;

  Home({Key key, @required this.dataProvider}) : super(key: key);


  final RefreshController _refreshController = RefreshController(initialRefresh: false);


  void _onRefresh() async {
    await dataProvider.fetchPost();

    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {

    List<Post> posts = Provider.of<DataProvider>(context).posts;

    return Scaffold(
      appBar: AppBar(
        title: Text('Future Posts'),
      ),
      body: posts.isEmpty ? Center(
        child: CircularProgressIndicator(),
      ) : SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        header: WaterDropHeader(),
        footer: CustomFooter(builder: (context, LoadStatus mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text('pull down load');
          }
          else if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          }
          else if (mode == LoadStatus.failed) {
            body = Text("Load Failed!Click retry!");
          }
          else {
            body = Text("No more Data");
          }

          return Container(
            height: 55.0,
            child: Center(child:body),
          );
        }),
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(posts[index].title),
              subtitle: Text(posts[index].description),
            );
        }),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return AddPost();
            }));
          },
          child: Icon(
            Icons.add
          ),
        ),
    );
  }
}