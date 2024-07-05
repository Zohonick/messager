import 'package:flutter/material.dart';

List<Color> colorByInitials(String? initials) {
  final firstKey = initials?.split('').first ?? '';
  switch (firstKey) {
    case "В":
      return const [
        Color.fromRGBO(31, 219, 95, 1),
        Color.fromRGBO(49, 199, 100, 1)
      ];
    case 'П':
      return const [
        Color.fromRGBO(0, 172, 246, 1),
        Color.fromRGBO(0, 109, 237, 1)
      ];
    default:
      return const [
        Color.fromRGBO(246, 103, 0, 1),
        Color.fromRGBO(237, 57, 0, 1)
      ];
  }
}

Widget circleContainer(String? initialName) {
  return Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        colors: colorByInitials(initialName),
      ),
    ),
  );
}
