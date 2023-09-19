import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

PreferredSizeWidget customAppBar(BuildContext context){
  return AppBar(
    title: SizedBox(
      width: 83,
      height: 33,
      child: SvgPicture.asset(
        "assets/logos/mainlogo.svg",
        fit: BoxFit.contain,
      ),
    ),
    titleSpacing: 0,
    backgroundColor: Colors.white,
    leading: BackButton(
      color: const Color(0xff00ABB3),
      onPressed: Navigator.of(context).pop,
    ),
    actions: [
      Container(
        margin: const EdgeInsets.only(right: 6),
        child: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications, size: 32, color: Color(0xff00ABB3),),
          padding: EdgeInsets.zero,
        ),
      ),
    ],
  );
}