import 'package:flutter/material.dart';

Widget userStatusBoxBuilder({required int active}) {
  final Map<int, dynamic> statusMap = {
    1: {
      "backgroundColor": const Color(0xffA7E9B5),
      "textColor": const Color(0xff197517),
      "text": "Active",
    },
    0: {
      "backgroundColor": const Color(0xffE9A7A7),
      "textColor": const Color(0xff852020),
      "text": "Inactive",
    },
  };

  if (statusMap.containsKey(active)) {
    final backgroundColor = statusMap[active]['backgroundColor'];
    final textColor = statusMap[active]['textColor'];
    final text = statusMap[active]['text'];
    return Container(
      padding: const EdgeInsets.only(left: 6, right: 6, top: 2, bottom: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(100),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor),
      ),
    );
  }
  return const SizedBox.shrink();
}
