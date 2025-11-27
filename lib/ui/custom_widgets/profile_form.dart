import 'package:flutter/material.dart';

import '../../customs.dart';

Widget buildFormField({
  required String label,
  required String hintText,
  required TextEditingController controller,
  required IconData icon,
  TextInputType keyboardType = TextInputType.text,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[300] ?? Colors.grey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: TextField(
          cursorColor: AppColors.primaryGreen,
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
            prefixIcon: Icon(
              icon,
              size: 20,
              color: AppColors.primaryGreen.withOpacity(0.6),
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 0),
          ),
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ),
    ],
  );
}
