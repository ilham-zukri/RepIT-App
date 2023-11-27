import 'package:flutter/material.dart';

Widget regularTextFieldBuilder({required String labelText, required TextEditingController controller, required bool obscureText, String? hintText, bool enabled = true}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        labelText,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black),
      ),
      Container(
        margin: const EdgeInsets.only(top: 8),
        height: 41,
        child: TextField(
          enabled: enabled,
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: const EdgeInsets.all(10),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget descriptionTextFieldBuilder({required String labelText, required TextEditingController controller, String? hintText, bool enabled = true}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        labelText,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black),
      ),
      Container(
        margin: const EdgeInsets.only(top: 8),
        height: 112,
        child: TextField(
          enabled: enabled,
          maxLines: 100,
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: const EdgeInsets.all(10),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    ]
  );
}