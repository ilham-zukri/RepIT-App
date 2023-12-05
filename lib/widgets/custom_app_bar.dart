import 'package:flutter/material.dart';

PreferredSizeWidget customAppBar(BuildContext context, String title,
    [String? additionalAction,
    VoidCallback? action,
    String? additionalAction2,
    VoidCallback? action2]) {
  return AppBar(
    title: Text(
      title,
      style: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff00ABB3)),
    ),
    titleSpacing: 0,
    backgroundColor: Colors.white,
    leading: BackButton(
      color: const Color(0xff00ABB3),
      onPressed: Navigator.of(context).pop,
    ),
    actions: [
      if(additionalAction == 'setting' && action != null)
        Container(
          margin: const EdgeInsets.only(right: 6),
          child: IconButton(
            onPressed: action2,
            icon: const Icon(
              Icons.settings,
              size: 32,
              color: Color(0xff00ABB3),
            ),
            padding: EdgeInsets.zero,
          ),
        ),

      if (additionalAction2 == 'repair_history' && action2 != null)
        Container(
          margin: const EdgeInsets.only(right: 6),
          child: IconButton(
            onPressed: action2,
            icon: const Icon(
              Icons.construction,
              size: 32,
              color: Color(0xff00ABB3),
            ),
            padding: EdgeInsets.zero,
          ),
        ),
      if ((additionalAction2 == 'refresh' && action2 != null) || (additionalAction == 'refresh' && action != null))
        Container(
          margin: const EdgeInsets.only(right: 6),
          child: IconButton(
            onPressed: action2 ?? action,
            icon: const Icon(
              Icons.refresh ,
              size: 32,
              color: Color(0xff00ABB3),
            ),
            padding: EdgeInsets.zero,
          ),
        ),


      (additionalAction == 'qr' && action != null)
          ? Container(
              margin: const EdgeInsets.only(right: 6),
              child: IconButton(
                onPressed: action,
                icon: const Icon(
                  Icons.qr_code_2,
                  size: 32,
                  color: Color(0xff00ABB3),
                ),
                padding: EdgeInsets.zero,
              ),
            )
          : const SizedBox.shrink(),
      (additionalAction == 'add' && action != null)
          ? Container(
              margin: const EdgeInsets.only(right: 6),
              child: IconButton(
                onPressed: action,
                icon: const Icon(
                  Icons.add,
                  size: 32,
                  color: Color(0xff00ABB3),
                ),
                padding: EdgeInsets.zero,
              ),
            )
          : const SizedBox.shrink(),
      (additionalAction == 'purchaseItems' && action != null)
          ? Container(
              margin: const EdgeInsets.only(right: 6),
              child: IconButton(
                onPressed: action,
                icon: const Icon(
                  Icons.assignment,
                  size: 32,
                  color: Color(0xff00ABB3),
                ),
                padding: EdgeInsets.zero,
              ),
            )
          : const SizedBox.shrink(),
      (additionalAction == 'spare_parts' && action != null)
          ? Container(
              margin: const EdgeInsets.only(right: 6),
              child: IconButton(
                onPressed: action,
                icon: const Icon(
                  Icons.construction,
                  size: 32,
                  color: Color(0xff00ABB3),
                ),
                padding: EdgeInsets.zero,
              ),
            )
          : const SizedBox.shrink(),
    ],
  );
}
