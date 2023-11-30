import 'package:flutter/material.dart';

Widget statusBoxBuilder(String status, String usage) {
  var padding = (usage == "detail")
      ? const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8)
      : const EdgeInsets.only(left: 6, right: 6, top: 2, bottom: 2);

  final Map<String, dynamic> statusMap = {
    "Ready": {
      "backgroundColor": const Color(0xff98BFFA),
      "textColor": const Color(0xff12315F),
    },
    "Deployed": {
      "backgroundColor": const Color(0xffAEE2AA),
      "textColor": const Color(0xff11410D),
    },
    "On Repair": {
      "backgroundColor": const Color(0xffFAD398),
      "textColor": const Color(0xff885B17),
    },
    "Reserve": {
      "backgroundColor": const Color(0xffAADAE9),
      "textColor": const Color(0xff0C4B5F),
    },
    "Scrapped": {
      "backgroundColor": const Color(0xffEDA8A8),
      "textColor": const Color(0xff891F1F),
    },
  };
  if (statusMap.containsKey(status)) {
    final backgroundColor = statusMap[status]['backgroundColor'];
    final textColor = statusMap[status]['textColor'];
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(100)),
      ),
      child: Text(
        status,
        style: TextStyle(color: textColor),
      ),
    );
  }

  return const SizedBox.shrink();
}
