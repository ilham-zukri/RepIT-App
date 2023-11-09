import 'package:flutter/material.dart';

Widget categoryBoxBuilder(String category) {
  final Map<String, dynamic> categoryMap = {
    "Regular": {
      "backgroundColor": const Color(0xff98BFFA),
      "textColor": const Color(0xff12315F),
    },
    "Sistem": {
      "backgroundColor": const Color(0xffAEE2AA),
      "textColor": const Color(0xff11410D),
    }
  };

  if (categoryMap.containsKey(category)) {
    final backgroundColor = categoryMap[category]['backgroundColor'];
    final textColor = categoryMap[category]['textColor'];
    return Container(
      padding: const EdgeInsets.only(left: 6, right: 6, top: 2, bottom: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(100)),
      ),
      child: Text(
        category,
        style: TextStyle(color: textColor),
      ),
    );
  }

  return const SizedBox.shrink();
}
