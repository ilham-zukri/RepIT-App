import 'package:flutter/material.dart';

Widget flagBoxBuilder(String flag, String usage){
  var padding = (usage == "detail")
      ? const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8)
      : const EdgeInsets.only(left: 6, right: 6, top: 2, bottom: 2);
  final Map<String, dynamic> flagMap = {
    "Need to Resolve": {
      "backgroundColor": const Color(0xffFAD398),
      "textColor": const Color(0xff885B17),
    },
    "Need to Respond": {
      "backgroundColor": const Color(0xffEDA8A8),
      "textColor": const Color(0xff891F1F),
    },
  };
  if (flagMap.containsKey(flag)) {
    final backgroundColor = flagMap[flag]['backgroundColor'];
    final textColor = flagMap[flag]['textColor'];
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(100)),
      ),
      child: Text(
        flag,
        style: TextStyle(color: textColor),
      ),
    );
  }
  return const SizedBox.shrink();
}