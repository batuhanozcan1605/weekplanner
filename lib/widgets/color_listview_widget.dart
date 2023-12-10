import 'package:flutter/material.dart';
import 'package:weekplanner/constants.dart';

class ColorListView extends StatefulWidget {
  final Function(Color) onColorSelected;
  final Color selectedColor;

  ColorListView({required this.onColorSelected, required this.selectedColor});

  @override
  State<ColorListView> createState() => _ColorListViewState();
}

class _ColorListViewState extends State<ColorListView> {
  final List<Color> colors = [
    Color(0xFF673AB7),
    Color(0xFFFFC107),
    Color(0xFF4CAF50),
    Color(0xFF42A1E9),
    Color(0xFFE53935),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: colors.length,
        itemBuilder: (context, index) {
          final bool isSelected = widget.selectedColor == colors[index];

          return GestureDetector(
            onTap: () {
              widget.onColorSelected(colors[index]);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12), // Add horizontal padding
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: colors[index],
                  ),
                  if (isSelected)
                    Container(
                      height: 22,
                      width: 22,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                        border: Border.all(width: 2.0, color: Constants.softColor),
                      ),
                    )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}