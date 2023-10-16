import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shortcut/bottom_navigation_widget.dart';
import 'package:shortcut/drawer_widget.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class RecentScreen extends StatelessWidget {
  final List<String> lst;
  RecentScreen(this.lst);
  @override
  Widget build(BuildContext context) {
    var mainHeight = MediaQuery.of(context).size.height;
    var mainWidth = MediaQuery.of(context).size.width;
    var statusBarHeight = MediaQuery.of(context).padding.top;
    final appBar = AppBar(
      title: Container(
        width: mainWidth,
        // color: Colors.black,
        child: Center(
          child: Text(
            "Recent Trips",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
    double appBarHeight = appBar.preferredSize.height + statusBarHeight;
    double appHeight = mainHeight - appBarHeight;
    return Scaffold(
      appBar: appBar,
      body: ListView.separated(
        itemBuilder: (context, index) {
          String dict = lst[index];
          Map myMap = jsonDecode(dict);
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.black,
              child: Text(
                "${index + 1}",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
                "${myMap['From'].substring(0, (10 < myMap['From'].length ? 10 : myMap['From'].length))} -> ${myMap['Destination'].substring(0, (10 < myMap['Destination'].length ? 10 : myMap['Destination'].length))}"),
            subtitle: Text(
                "${myMap['hour']}:${myMap['min']}  ${myMap['date']}/${myMap['month']}/${myMap['year']}"),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            thickness: 1,
            height: 20,
          );
        },
        itemCount: lst.length,
      ),
      endDrawer: CustomDrawer(mainHeight: mainHeight),
      bottomNavigationBar: BottomNavigation(
        appHeight: appHeight,
        mainHeight: appHeight,
      ),
    );
  }
}
