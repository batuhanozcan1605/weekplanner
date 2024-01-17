import 'package:flutter/material.dart';
import 'package:weekplanner/constants.dart';

class ColorListView extends StatefulWidget {
  final Function(Color) onColorSelected;
  final Color selectedColor;

  const ColorListView({super.key, required this.onColorSelected, required this.selectedColor});

  @override
  State<ColorListView> createState() => _ColorListViewState();
}

class _ColorListViewState extends State<ColorListView> {
  final List<Color> colors = <Color>[
    const Color(0xFF673AB7),
    const Color(0xFFFFC107),
    const Color(0xFFE53935),
    const Color(0xFF42A1E9),
    const Color(0xFF4CAF50),
    Colors.brown
  ];

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 50,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: colors.length,
        itemBuilder: (context, index) {
          final bool isSelected = widget.selectedColor == colors[index];

          return GestureDetector(
            onTap: () {
              widget.onColorSelected(colors[index]);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5), // Add horizontal padding
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
                          borderRadius: const BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
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