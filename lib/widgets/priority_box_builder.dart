import 'package:flutter/material.dart';

Widget priorityBoxBuilder(String priority, String usage) {
  var padding = (usage == "detail")
      ? const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8)
      : const EdgeInsets.only(left: 6, right: 6, top: 2, bottom: 2);

  final Map<String, dynamic> priorityMap = {
    "Low": {
      "backgroundColor": const Color(0xffA7E9B5),
      "textColor": const Color(0xff197517),
    },
    "Medium": {
      "backgroundColor": const Color(0xffAEE2AA),
      "textColor": Colors.black54,
    },
    "High": {
      "backgroundColor": const Color(0xffE9DAA7),
      "textColor": const Color(0xff4E4121),
    },
    "Urgent": {
      "backgroundColor": const Color(0xffE9A7A7),
      "textColor": const Color(0xff852020),
    },
  };
  if (priorityMap.containsKey(priority)) {
    final backgroundColor = priorityMap[priority]['backgroundColor'];
    final textColor = priorityMap[priority]['textColor'];
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(100)),
      ),
      child: Text(
        priority,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
      ),
    );
  }

  return const SizedBox.shrink();
}
