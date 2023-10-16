import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatefulWidget {
  final double mainHeight;

  const CustomDrawer({Key? key, required this.mainHeight}) : super(key: key);
  @override
  State<CustomDrawer> createState() => CustomDrawerState();
}

class CustomDrawerState extends State<CustomDrawer> {
  late SharedPreferences _prefs;
  String user_name = "User Name";

  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  Future<void> initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    String? name = _prefs.getString("user_name");
    if (name != null) {
      setState(() {
        user_name = name;
      });
    }
    String? imageString = _prefs.getString('user_image');
    if (imageString != null) {
      setState(() {
        _imageBytes = base64Decode(imageString);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageBytes != null
                        ? MemoryImage(_imageBytes!)
                        : AssetImage('assets/images/defaultprofile.png')
                            as ImageProvider,
                  ),
                  Text(
                    "$user_name",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(children: [
                ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text('Notification'),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Setting'),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.accessibility),
                  title: Text('Accessibility'),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.contact_page),
                  title: Text('Contact Us'),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.phone_in_talk),
                  title: Text('HelpLine SpeedDail'),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.accessible),
                  title: Text('Quick Access'),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),
              ]),
              Container(
                margin: EdgeInsets.only(top: widget.mainHeight * 0.2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.dark_mode),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.notification_add),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.share),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.download),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
