import 'package:contact/pages/AddContact.dart';
import 'package:contact/pages/CategoryPage.dart';
import 'package:contact/pages/MyHomePage.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var materialApp = MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => MyHomePage(),
        'addContact': (context) => AddContact(),
        'categoryPage': (context) => CategoryPage(),
      },
    );
    return materialApp;
  }
}
