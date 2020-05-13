import 'package:flutter/material.dart';

//            final info = await PackageInfo.fromPlatform();

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('このアプリについて')),
      body: _buildBodyPart(context),
    );
  }

  Widget _buildBodyPart(BuildContext context) {
    return Column(children: []);
  }
}
