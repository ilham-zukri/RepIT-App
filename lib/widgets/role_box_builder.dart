import 'package:flutter/material.dart';

Widget roleBoxBuilder(String role) {
  final Map<String, dynamic> rolesMap = {
    "User": {
      "backgroundColor": const Color(0xffA7E9B5),
      "textColor": const Color(0xff197517),
    },
    "Supervisor": {
      "backgroundColor": const Color(0xffB8A7E9),
      "textColor": const Color(0xff58148E),
    },
    "Dev": {
      "backgroundColor": const Color(0xffE9DAA7),
      "textColor": const Color(0xff4E4121),
    },
    "Staff IT": {
      "backgroundColor": const Color(0xff98BFFA),
      "textColor": const Color(0xff12315F),
    },
    "Supervisor IT": {
      "backgroundColor": const Color(0xffA7E9E9),
      "textColor": const Color(0xff2F546E),
    },
  };
  if (rolesMap.containsKey(role)) {
    final backgroundColor = rolesMap[role]['backgroundColor'];
    final textColor = rolesMap[role]['textColor'];
    return Container(
      padding: const EdgeInsets.only(left: 6, right: 6, top: 2, bottom: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(100),
        ),
      ),
      child: Text(
        role,
        style: TextStyle(color: textColor),
      ),
    );
  }
  return const SizedBox.shrink();
}
