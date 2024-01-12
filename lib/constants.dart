import 'dart:ui';
import 'package:flutter/material.dart';

class Constants {

  static final primaryColor =  Color(0xFFBFB528);
  static final softColor = Color(0xFFF3E7E7);
  static final lightGrey = Color(0xFF74736F);
  static final themePurple = Color(0xFFD0BBFF);


  Widget myText(input) => Text(
    '$input',
    style: TextStyle(color: softColor),
  );

  Widget eventCard(String subject, IconData icon, Color color) => Builder(
      builder: (context) {
        ColorScheme colorScheme = Theme.of(context).colorScheme;
        return Container(
          color: Colors.transparent,
          child: Column(
            children: [
              Flexible(
                flex: 4,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(11.0),
                    ),

                    child: Center(child: Icon(icon, color: Colors.white,)),
                  ),
                ),
              ),
              Flexible(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Text(
                        subject,
                        style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 16,
                          color: colorScheme.onBackground,
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        );
      }
  );
}