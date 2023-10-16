import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shortcut/drawer_widget.dart';
import 'package:shortcut/snackbar_utils.dart';
import 'package:shortcut/bottom_navigation_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);
  @override
  State<DashBoardScreen> createState() => DashBoardScreenState();
  // DashBoardScreenState createState() => DashBoardScreenState();
}

class DashBoardScreenState extends State<DashBoardScreen> {
  var _FromInput = TextEditingController();
  var _DestinationInput = TextEditingController();

  Completer<GoogleMapController> _controller = Completer();
  loc.Location _location = loc.Location();
  Set<Marker> _markers = {};
  List<LatLng> _busRoute = [
    LatLng(17.4565, 78.3218), // University of Hyderabad
    LatLng(17.4571, 78.3220), // Bus Stop 1
    LatLng(17.4590, 78.3225), // Bus Stop 2
    LatLng(17.4605, 78.3240), // Bus Stop 3
    LatLng(17.4618, 78.3255), // Bus Stop 4
  ];

  static const CameraPosition _kUniversityOfHyderabad = CameraPosition(
    target: LatLng(17.4565, 78.3218),
    zoom: 14,
  );

  loc.LocationData? _currentLocation;

  @override
  void initState() {
    super.initState();
    _addMarkers();
    _configureLocation();
  }

  void _addMarkers() {
    _markers.add(_createMarker('UniversityOfHyderabad',
        LatLng(17.4565, 78.3218), 'University of Hyderabad'));

    for (int i = 1; i <= 4; i++) {
      _markers.add(_createMarker('BusStop$i', _busRoute[i - 1], 'Bus Stop $i'));
    }
  }

  Marker _createMarker(String markerId, LatLng position, String title) {
    return Marker(
      markerId: MarkerId(markerId),
      position: position,
      infoWindow: InfoWindow(title: title),
    );
  }

  void _configureLocation() async {
    await _checkLocationPermission();

    _location.onLocationChanged.listen((loc.LocationData currentLocation) {
      print(
          "Current Location: ${currentLocation.latitude}, ${currentLocation.longitude}");
      setState(() {
        _currentLocation = currentLocation;
      });
    });

    _location.onLocationChanged.handleError((dynamic error) {
      print("Error getting location: $error");
    });

    print("Location configured");
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        _showServiceDeniedDialog();
        return;
      }
    }

    PermissionStatus permissionStatus = await _location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await _location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        _showPermissionDeniedDialog();
      }
    }
  }

  void _showServiceDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Location Service Disabled"),
          content: Text(
              "To use this app, please enable location services in your device settings."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Location Permission Denied"),
          content: Text(
              "To use this app, please grant location permission in the app settings."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
            TextButton(
              onPressed: () {
                loc.Location().requestPermission();
                Navigator.of(context).pop();
              },
              child: Text("Try Again"),
            ),
          ],
        );
      },
    );
  }

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
                child: SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: GoogleMap(
                          initialCameraPosition: _kUniversityOfHyderabad,
                          markers: _markers,
                          polylines: {
                            Polyline(
                              polylineId: PolylineId('busRoute'),
                              color: Colors.blue,
                              width: 5,
                              points: _busRoute,
                            ),
                          },
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                          myLocationEnabled: true,
                          trafficEnabled: true,
                        ),
                      ),
                      if (_currentLocation != null)
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 2),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Text(
                            "Current Location: ${_currentLocation!.latitude}, ${_currentLocation!.longitude}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Container(
                height: appHeight * 0.1,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              height: appHeight * 0.045,
                              width: mainWidth * 0.4,
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
                                onPressed: () => _showRoute(),
                                child: Text('Show Route'),
                              ),
                            ),
                            SizedBox(
                              height: appHeight * 0.045,
                              width: mainWidth * 0.4,
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
                                onPressed: () => _showRoute(),
                                child: Text('Navigate'),
                              ),
                            ),
                          ]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            height: appHeight * 0.045,
                            width: mainWidth * 0.4,
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
                              onPressed: () => _getCurrentLocation(),
                              child: Text('Current Location'),
                            ),
                          ),
                          SizedBox(
                            height: appHeight * 0.045,
                            width: mainWidth * 0.4,
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
                                  errormeg =
                                      "Please Enter Destination location";
                                }

                                if (errormeg.isEmpty) {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  List<String>? temp = await prefs
                                      .getStringList("PreviousJourney");
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
                                  await prefs.setStringList(
                                      "PreviousJourney", temp);
                                  print(temp);
                                } else {
                                  showCustomSnackBar(
                                      context, errormeg, mainHeight);
                                }
                              },
                              child: Text(
                                "Make Plan",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
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

  Future<void> _getCurrentLocation() async {
    try {
      _currentLocation = await _location.getLocation();
      print(
          "Current Location: ${_currentLocation?.latitude}, ${_currentLocation?.longitude}");
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _showRoute() {
    if (_currentLocation != null) {
      _controller.future.then((controller) {
        controller.animateCamera(
          CameraUpdate.newLatLng(_currentLocation!.toLatLng()),
        );
      });

      // Add your logic to display a route between the current location and the University of Hyderabad
      _controller.future.then((controller) {
        controller.showMarkerInfoWindow(MarkerId('UniversityOfHyderabad'));
        // You can add more logic related to the route here
      });
    }
  }

  void _findCurrentLocation() {
    if (_currentLocation != null) {
      _controller.future.then((controller) {
        controller.animateCamera(
          CameraUpdate.newLatLng(_currentLocation!.toLatLng()),
        );
      });
    }
  }
}

extension LocationDataExtension on loc.LocationData {
  LatLng toLatLng() {
    return LatLng(latitude!, longitude!);
  }
}
