import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PreviewFullScreen extends StatelessWidget{
  final ImageProvider imageProvider;

  const PreviewFullScreen({super.key, required this.imageProvider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
      ),
      body: PhotoView(
        minScale: PhotoViewComputedScale.contained * 1.0,
        maxScale: PhotoViewComputedScale.contained * 3.0,
        imageProvider: imageProvider,
      ),
    );
  }
}