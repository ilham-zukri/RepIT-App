import 'package:flutter/material.dart';

Widget purchaseStatusBoxBuilder(String status, String usage){
  var padding = (usage == "detail")
      ? const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8)
      : const EdgeInsets.only(left: 6, right: 6, top: 2, bottom: 2);

  final Map<String, dynamic> statusMap = {
    "Done": {
      "backgroundColor": const Color(0xffA7E9B5),
      "textColor": const Color(0xff197517),
    },
    "In Progress": {
      "backgroundColor": const Color(0xff98BFFA),
      "textColor": const Color(0xff12315F),
    },
    "Cancelled": {
      "backgroundColor": const Color(0xffE9A7A7),
      "textColor": const Color(0xff852020),
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