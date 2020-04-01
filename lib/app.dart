import 'package:flutter/material.dart';
import 'package:post_request/DataProvider.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
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
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.green,
          ),
        home: Home(
          dataProvider: _dataProvider,
        ),
      ),
    );
  }
}
