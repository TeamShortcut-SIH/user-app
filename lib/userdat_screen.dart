import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shortcut/bottom_navigation_widget.dart';
import 'package:shortcut/drawer_widget.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => UserProfileScreenState();
}

class UserProfileScreenState extends State<UserProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  late SharedPreferences _prefs;
  Uint8List? _imageBytes;
  var isUserNameEable = false;
  var user_name = TextEditingController(text: "User Name");
  // "User Name";
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
        user_name.text = name;
      });
    }
    String? imageString = _prefs.getString('user_image');
    if (imageString != null) {
      setState(() {
        _imageBytes = base64Decode(imageString);
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      setState(() {
        if (pickedFile != null) {
          _image = pickedFile;
          _saveImageToPrefs(_image!);
          initSharedPreferences();
        } else {
          print('No image selected.');
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _saveImageToPrefs(XFile image) async {
    final bytes = await image.readAsBytes();
    final base64String = base64Encode(bytes);
    await _prefs.setString('user_image', base64String);
    setState(() {
      _imageBytes = bytes;
    });
  }

  void _toggleTextField() {
    setState(() {
      isUserNameEable = !isUserNameEable;
      user_name.text = "";
    });
  }

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
            "${user_name.text} Profile",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
    double appBarHeight = appBar.preferredSize.height + statusBarHeight;
    double appHeight = mainHeight - appBarHeight;
    return Scaffold(
      appBar: appBar,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 200,
              height: 200,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 100,
                    backgroundImage: _imageBytes != null
                        ? MemoryImage(_imageBytes!)
                        : _image != null
                            ? FileImage(File(_image!.path))
                            : AssetImage('assets/images/defaultprofile.png')
                                as ImageProvider,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: IconButton(
                      color: Colors.black,
                      hoverColor: Colors.blueAccent,
                      focusColor: Colors.blueAccent,
                      onPressed: () {
                        _pickImage(ImageSource
                            .gallery); // You can change to ImageSource.camera for taking a new picture
                      },
                      icon: Icon(Icons.edit),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 20,
            ),
            ListTile(
              title: TextField(
                controller: user_name,
                enabled: isUserNameEable,
                decoration: InputDecoration(
                  border:
                      isUserNameEable ? OutlineInputBorder() : InputBorder.none,
                ),
                textAlign: TextAlign.center,
                onSubmitted: (data) {
                  setState(() {
                    user_name.text = data;
                    isUserNameEable = false;
                    _prefs.setString("user_name", data);
                  });
                },
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _toggleTextField();
                },
              ),
            )
          ],
        ),
      ),
      endDrawer: CustomDrawer(mainHeight: mainHeight),
      bottomNavigationBar: BottomNavigation(
        mainHeight: mainHeight,
        appHeight: appHeight,
      ),
    );
  }
}
