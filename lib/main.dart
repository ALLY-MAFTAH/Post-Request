import 'package:flutter/material.dart';
import 'package:post_request/AddPost.dart';
import 'package:post_request/DataProvider.dart';
import 'package:provider/provider.dart';


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
      home: Home(),
    ),
    );
  }
}



class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<DataProvider>(context).posts;
    return Scaffold(
      appBar: AppBar(
        title: Text('Future Posts'),
      ),
      body: posts.isEmpty ? Center(
        child: CircularProgressIndicator(),
      ) : ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(posts[index].title),
            subtitle: Text(posts[index].description),
          );
        }),

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