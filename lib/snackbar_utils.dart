import 'package:flutter/material.dart';

void showCustomSnackBar(
    BuildContext context, String errorText, double mainHeight) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Container(
        child: Center(
          child: Text(
            errorText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.red,
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        height: mainHeight * 0.1,
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    ),
  );
}
