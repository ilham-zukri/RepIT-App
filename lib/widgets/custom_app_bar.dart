import 'package:flutter/material.dart';

PreferredSizeWidget customAppBar(BuildContext context, String title,
    [String? additionalAction, VoidCallback? action]) {
  return AppBar(
    title: Text(
      title,
      style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xff00ABB3)
      ),
    ),
    titleSpacing: 0,
    backgroundColor: Colors.white,
    leading: BackButton(
      color: const Color(0xff00ABB3),
      onPressed: Navigator
          .of(context)
          .pop,
    ),
    actions: [
      (additionalAction == 'qr' && action != null) ? Container(
        margin: const EdgeInsets.only(right: 6),
        child: IconButton(
          onPressed: action,
          icon: const Icon(
            Icons.qr_code_2, size: 32, color: Color(0xff00ABB3),),
          padding: EdgeInsets.zero,
        ),
      ) : const SizedBox.shrink(),

      Container(
        margin: const EdgeInsets.only(right: 6),
        child: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications, size: 32, color: Color(0xff00ABB3),),
          padding: EdgeInsets.zero,
        ),
      ),
    ],
  );
}