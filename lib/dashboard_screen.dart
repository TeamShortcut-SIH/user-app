import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shortcut/drawer_widget.dart';
import 'package:shortcut/snackbar_utils.dart';
import 'package:shortcut/bottom_navigation_widget.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);
  @override
  State<DashBoardScreen> createState() => DashBoardScreenState();
  // DashBoardScreenState createState() => DashBoardScreenState();
}

class DashBoardScreenState extends State<DashBoardScreen> {
  var _FromInput = TextEditingController();
  var _DestinationInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var mainHeight = MediaQuery.of(context).size.height;
    var mainWidth = MediaQuery.of(context).size.width;
    double appHeight = mainHeight;
    return Scaffold(
      // appBar: appBar,
      body: SingleChildScrollView(
        child: SizedBox(
          height: appHeight - appHeight * 0.1,
          width: mainWidth,
          child: Column(
            children: [
              Container(
                height: appHeight * 0.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Container(
                            // padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(
                                left: 20, top: 15, right: 10, bottom: 10),
                            height: 35,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              controller: _FromInput,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 1, 87, 7)),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(15),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3,
                                        color: const Color.fromARGB(
                                            255, 240, 105, 105)),
                                    borderRadius: BorderRadius.circular(50.0)),
                                labelText: 'From',
                                // helperText: "Enter Location"
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 20, top: 15, right: 10, bottom: 10),
                            height: 30,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  ///write button action
                                });
                              },
                              child: Text("Nearest"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Container(
                            // padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(
                                left: 20, top: 15, right: 10, bottom: 10),
                            height: 35,
                            child: TextField(
                              controller: _DestinationInput,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 1, 87, 7)),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(15),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3,
                                        color: const Color.fromARGB(
                                            255, 240, 105, 105)),
                                    borderRadius: BorderRadius.circular(50.0)),
                                labelText: 'Destination',
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 20, top: 15, right: 10, bottom: 10),
                            height: 30,
                            child: ElevatedButton(
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                List<String>? temp = await prefs
                                    .getStringList("PreviousJourney");
                                if (temp != null) {
                                  Map dict = jsonDecode(temp[temp.length - 1]);
                                  _DestinationInput.text = dict["Destination"];
                                } else {
                                  showCustomSnackBar(
                                      context,
                                      "Please Make At least one plan",
                                      mainHeight);
                                }
                              },
                              child: Text("Recent"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: appHeight * 0.6,
                color: Colors.black12,
                child: Center(
                  child: Text('Map Viewer'),
                ),
              ),
              Container(
                height: appHeight * 0.1,
                child: Center(
                  child: Container(
                    width: mainWidth / 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(50),
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(5),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        String errormeg = "";
                        if (_FromInput.text.isEmpty &&
                            _DestinationInput.text.isEmpty) {
                          errormeg =
                              "Please Enter Your and Destination location";
                        } else if (_FromInput.text.isEmpty) {
                          errormeg = "Please Enter Your location";
                        } else if (_DestinationInput.text.isEmpty) {
                          errormeg = "Please Enter Destination location";
                        }

                        if (errormeg.isEmpty) {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          List<String>? temp =
                              await prefs.getStringList("PreviousJourney");
                          var datetime = DateTime.now();
                          print(datetime.day);
                          Map<String, dynamic> dict = {
                            "From": _FromInput.text,
                            "Destination": _DestinationInput.text,
                            "year": datetime.year,
                            "month": datetime.month,
                            "date": datetime.day,
                            "hour": datetime.hour,
                            "min": datetime.minute
                          };
                          if (temp == null) {
                            temp = [jsonEncode(dict)];
                          } else {
                            temp.add(jsonEncode(dict));
                          }
                          await prefs.setStringList("PreviousJourney", temp);
                          print(temp);
                        } else {
                          showCustomSnackBar(context, errormeg, mainHeight);
                        }
                      },
                      child: Text("Make Plan", style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      endDrawer: CustomDrawer(mainHeight: mainHeight),
      bottomNavigationBar: BottomNavigation(
        appHeight: appHeight,
        mainHeight: appHeight,
      ),
    );
  }
}
