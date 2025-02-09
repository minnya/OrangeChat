import 'package:orange_chat/components/commons/photo_full_preview.dart';
import 'package:flutter/material.dart';

class PhotoPreviewRound extends StatelessWidget {
  final ImageProvider? imageProvider;
  final double radius;

  const PhotoPreviewRound(
      {super.key, required this.imageProvider, this.radius = 60});

  @override
  Widget build(BuildContext context) {
    return imageProvider == null
        ? CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          )
        : GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        PreviewFullScreen(imageProvider: imageProvider!))),
            child: CircleAvatar(
              radius: radius,
              backgroundImage: imageProvider,
            ));
  }
}

class PhotoPreviewRoundedRectangle extends StatelessWidget {
  final ImageProvider? imageProvider;

  const PhotoPreviewRoundedRectangle({super.key, required this.imageProvider});

  @override
  Widget build(BuildContext context) {
    return PhotoPreviewRectangle(
      imageProvider: imageProvider,
      radius: 0,
    );
  }
}

class PhotoPreviewRectangle extends StatelessWidget {
  final ImageProvider? imageProvider;
  final double radius;

  const PhotoPreviewRectangle({
    super.key,
    required this.imageProvider,
    this.radius = 0,
  });

  @override
  Widget build(BuildContext context) {
    return imageProvider == null
        ? const SizedBox()
        : GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          PreviewFullScreen(imageProvider: imageProvider!)));
            },
            child: Container(
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(radius),
                    image: DecorationImage(
                      image: imageProvider!,
                      fit: BoxFit.cover,
                    ))),
          );
  }
}
