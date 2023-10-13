import 'package:flutter/material.dart';

Widget loadingOverlay(bool isLoading, BuildContext context) {
  Size size = MediaQuery.of(context).size;
  return (isLoading)
      ? Container(
          color: Colors.black26,
          width: size.width,
          height: size.height,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        )
      : const SizedBox.shrink();
}
