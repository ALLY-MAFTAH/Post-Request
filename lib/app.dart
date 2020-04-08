import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:post_request/provider/DataProvider.dart';
import 'package:post_request/ui/login.dart';
import 'package:post_request/ui/splash.dart';
import 'package:provider/provider.dart';

import 'ui/home.dart';

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
            primarySwatch: Colors.red,
          ),
          home: MainScreen(
            dataProvider: _dataProvider,
          )),
    );
  }
}

class MainScreen extends StatelessWidget {
  final DataProvider dataProvider;

  const MainScreen({Key key, @required this.dataProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return SplashPage();
        if (!snapshot.hasData || snapshot.data == null) return LoginPage();
        return Home(
          dataProvider: dataProvider,
        );
      },
    );
  }
}
