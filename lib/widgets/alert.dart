import 'package:flutter/material.dart';
Widget alert(BuildContext context, String title, String content) {
  return AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff00ABB3),
          ),
          child: const Text("OK")),
    ],
  );
}