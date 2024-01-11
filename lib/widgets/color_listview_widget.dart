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
    Color(0xFFE53935),
    Color(0xFF42A1E9),
    Color(0xFF4CAF50),
    Colors.brown
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: colors.length,
        itemBuilder: (context, index) {
          final bool isSelected = widget.selectedColor == colors[index];

          return GestureDetector(
            onTap: () {
              widget.onColorSelected(colors[index]);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5), // Add horizontal padding
              child: Container(
                color: Colors.transparent,
                height: 40,
                width: 40,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: colors[index],
                    ),
                    if (isSelected)
                      Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                          border: Border.all(width: 2.0, color: Constants.softColor),
                        ),
                      )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}