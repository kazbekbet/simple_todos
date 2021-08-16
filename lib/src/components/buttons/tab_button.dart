import 'package:flutter/material.dart';
import 'package:flutter_movies/src/components/typography/typography.dart';

class TabButton extends StatelessWidget {
  final String text;
  final bool isActive;

  const TabButton({Key? key, required this.text, required this.isActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: ButtonTypography(
        text: text,
        color: isActive ? Colors.white : Colors.white70,
        toUpperCase: true,
      ),
    );
  }
}
