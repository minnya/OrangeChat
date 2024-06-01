import 'dart:async';

import 'package:orange_chat/components/commons/custom_container.dart';
import 'package:orange_chat/const/variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageGallery extends StatefulWidget {
  final List<String> imageUrls;

  const ImageGallery({super.key, required this.imageUrls});

  @override
  State<ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  List<Size> _imageSizes = [];

  @override
  void initState() {
    super.initState();
    _loadImageSizes();
  }

  void _loadImageSizes() async {
    for (var url in widget.imageUrls) {
      final image = Image.network("${ConstVariables.SUPABASE_HOSTNAME}$url");
      final completer = Completer<void>();
      image.image.resolve(ImageConfiguration()).addListener(
        ImageStreamListener((ImageInfo info, bool _) {
          _imageSizes.add(Size(info.image.width.toDouble(), info.image.height.toDouble()));
          completer.complete();
        }),
      );
      await completer.future;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      alignment: Alignment.center,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              height: _imageSizes.isNotEmpty
                  ? (constraints.maxWidth / _imageSizes[_currentPage].width) * _imageSizes[_currentPage].height
                  : 300, // Fallback height while loading
              child: PhotoViewGallery.builder(
                itemCount: widget.imageUrls.length,
                pageController: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage("${ConstVariables.SUPABASE_HOSTNAME}${widget.imageUrls[index]}"),
                    initialScale: PhotoViewComputedScale.contained,
                    minScale: PhotoViewComputedScale.contained * 1,
                    maxScale: PhotoViewComputedScale.covered * 1,
                  );
                },
                scrollPhysics: const BouncingScrollPhysics(),
                backgroundDecoration: const BoxDecoration(
                  color: Colors.black,
                ),
              ),
            );
          }
        ),
        Positioned(
          bottom: 10,
            child: _buildPageIndicator()
        ),
      ],
    );
  }

  Widget _buildPageIndicator() {
    return widget.imageUrls.length<=1
        ?const SizedBox()
        :Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.imageUrls.length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          height: 6,
          width: 6,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? Theme.of(context).colorScheme.surface
                : Colors.grey,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
