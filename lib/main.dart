import 'package:flutter/material.dart';
import 'package:whimsicalendar/pages/top_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whisimicalendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TopPage(),
    );
  }
}
