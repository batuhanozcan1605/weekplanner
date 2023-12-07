import 'dart:ui';
import 'package:flutter/material.dart';

class Constants {

  static final primaryColor =  Color(0xFFBFB528);
  static final softColor = Color(0xFFF3E7E7);
  static final lightGrey = Color(0xFF74736F);
  static final themePurple = Color(0xFFD0BBFF);


  Widget MyText(input) => Text(
    '$input',
    style: TextStyle(color: softColor),
  );
}