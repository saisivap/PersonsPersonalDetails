import 'package:flutter/material.dart';

late double height;
late double width;

Text textCustom(String text) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 16,
      color: Colors.blueGrey,
    ),
  );
}
Text smalltextCustom(String text) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 12,
      color: Colors.blueGrey.shade300,
    ),
  );
}

Text appbarText(String text) {
  return Text(
    text,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: 18,
      color: Colors.blueGrey,
      fontWeight: FontWeight.bold,
    ),
  );
}
