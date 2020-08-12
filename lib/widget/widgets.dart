import 'package:flutter/material.dart';

Widget actionBar(BuildContext context, String title) {
  return AppBar(
    title: Text(title),
  );
}

InputDecoration form(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      fontSize: 17,
    ),
  );
}

TextStyle smallText() {
  return TextStyle(fontSize: 15);
}

TextStyle simpleText() {
  return TextStyle(fontSize: 16);
}

TextStyle linkText() {
  return TextStyle(fontSize: 16, decoration: TextDecoration.underline, color: Colors.blue[500]);
}