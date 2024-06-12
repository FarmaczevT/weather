import 'package:flutter/material.dart';

class ButtonStyles {
  static final primaryButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.white, backgroundColor: Colors.blue,
    minimumSize: Size(double.infinity, 50),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

  static final secondaryButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.black, backgroundColor: Colors.white,
    minimumSize: Size(double.infinity, 50),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(color: Colors.black),
    ),
  );
}