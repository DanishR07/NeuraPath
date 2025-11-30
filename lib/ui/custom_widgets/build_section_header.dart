import 'package:flutter/material.dart';

Widget buildSectionHeader(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12, left: 4),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF4E6E58),
        letterSpacing: 1.2,
      ),
    ),
  );
}