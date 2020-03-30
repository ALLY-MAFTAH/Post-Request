import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:post_request/DataProvider.dart';
import 'package:post_request/home.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

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
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.green,
            textTheme: TextTheme(
                headline: GoogleFonts.robotoCondensed(),
                body1: GoogleFonts.robotoCondensed(),
                button: GoogleFonts.robotoCondensed(),
                title: GoogleFonts.eczar(), )),
        home: Home(
          dataProvider: _dataProvider,
        ),
        // home: PostCard(),
      ),
    );
  }
}
