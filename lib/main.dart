import 'package:flutter/material.dart';

import './pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter vision',
      theme: ThemeData(
          primarySwatch: Colors.orange,
          textTheme: Theme.of(context).textTheme.apply(fontFamily: "Poppins")),
      home: HomePage(),
    );
  }
}
