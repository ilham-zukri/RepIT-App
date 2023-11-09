import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatelessWidget {
  final String imageUrl;
  const ImageViewer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Image Viewer"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: PhotoView(
        imageProvider: NetworkImage(imageUrl),
      ),
    );
  }
}
