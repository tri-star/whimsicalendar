import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('このアプリについて')),
      body: _buildBodyPart(context),
    );
  }

  Widget _buildBodyPart(BuildContext context) {
    return FutureBuilder(
        future: PackageInfo.fromPlatform(),
        builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
          const titleWidget =
              Text('Whimsicalendar', style: TextStyle(fontSize: 20));

          if (!snapshot.hasData) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: titleWidget,
                    heightFactor: 2.0,
                  ),
                  Center(child: Text('Loading...'))
                ]);
          }

          PackageInfo info = snapshot.data;
          return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Center(child: titleWidget, heightFactor: 2.0),
            Center(child: Text('Version: ${info.version}'), heightFactor: 3.0),
            Center(
                child: Text('Flavor: ' +
                    Provider.of<Config>(context, listen: false).flavor),
                heightFactor: 3.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Icons made by '),
                InkWell(
                  child: Text('Freepik',
                      style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline)),
                  onTap: () async {
                    await launch('https://www.flaticon.com/authors/freepik');
                  },
                ),
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(' from '),
              InkWell(
                  child: Text('www.flaticon.com',
                      style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline)),
                  onTap: () async {
                    await launch('https://www.flaticon.com');
                  }),
            ])
          ]);
        });
  }
}
