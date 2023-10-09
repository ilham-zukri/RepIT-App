import 'package:flutter/material.dart';

Widget reqStatusBoxBuilder(String status, String usage){
  var padding = (usage == "detail")
      ? const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8)
      : const EdgeInsets.only(left: 6, right: 6, top: 2, bottom: 2);

  final Map<String, dynamic> statusMap = {
    "Approved": {
      "backgroundColor": const Color(0xffA7E9B5),
      "textColor": const Color(0xff197517),
    },
    "Requested": {
      "backgroundColor": const Color(0xffB8A7E9),
      "textColor": const Color(0xff58148E),
    },
    "Declined": {
      "backgroundColor": const Color(0xffE9A7A7),
      "textColor": const Color(0xff852020),
    },
    "Preparation": {
      "backgroundColor": const Color(0xffE9DAA7),
      "textColor": const Color(0xff4E4121),
    },
    "Done": {
      "backgroundColor": const Color(0xffA7E9E9),
      "textColor": const Color(0xff2F546E),
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