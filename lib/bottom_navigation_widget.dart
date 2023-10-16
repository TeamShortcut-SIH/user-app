import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shortcut/dashboard_screen.dart';
import 'package:shortcut/userdat_screen.dart';
import 'recent_screen.dart';
import 'snackbar_utils.dart';
// import your RecentScreen file here

class BottomNavigation extends StatelessWidget {
  final double appHeight;
  final double mainHeight;

  const BottomNavigation(
      {Key? key, required this.appHeight, required this.mainHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: appHeight * 0.1,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 50,
              margin: EdgeInsets.all(10),
              child: Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                    child: Icon(Icons.menu),
                  );
                },
              ),
            ),
            Container(
              height: 50,
              margin: EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashBoardScreen()),
                  );
                },
                child: Icon(Icons.home),
              ),
            ),
            Container(
              height: 50,
              margin: EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  List<String>? temp =
                      await prefs.getStringList("PreviousJourney");
                  if (temp != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RecentScreen(temp)),
                    );
                  } else {
                    showCustomSnackBar(
                        context, "Please Make At least one plan", mainHeight);
                  }
                },
                child: Icon(Icons.bookmark),
              ),
            ),
            Container(
              height: 50,
              margin: EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserProfileScreen()),
                  );
                },
                child: Icon(Icons.account_circle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
