import 'package:flutter/material.dart';

Widget sparePartTypeDropDownBuilder(BuildContext context,
    {required Future future,
    required String label,
    required int value,
    required void Function(dynamic) onChange}) {

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black),
      ),
      const SizedBox(
        height: 8,
      ),
      FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            List? data = snapshot.data;
            return DecoratedBox(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    isExpanded: true,
                    value: value,
                    items: data!.map((data) {
                      return DropdownMenuItem(
                          value: data['id'], child: Text(data['type']));
                    }).toList(),
                    onChanged: onChange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            );
          }
        },
      ),
    ],
  );
}
