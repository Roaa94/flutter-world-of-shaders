import 'package:flutter/material.dart';
import 'package:interactive_gallery/widgets/image_gallery_item.dart';

class ImageGalleryItemPage extends StatefulWidget {
  const ImageGalleryItemPage({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  final List<String> images;
  final int initialIndex;

  @override
  State<ImageGalleryItemPage> createState() => _ImageGalleryItemPageState();
}

class _ImageGalleryItemPageState extends State<ImageGalleryItemPage> {
  late final PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onVerticalDragStart: (details) {
          Navigator.of(context).pop();
        },
        child: PageView(
          controller: pageController,
          children: List.generate(
            widget.images.length,
            (index) => ImageGalleryItem(
              heroTag: '__hero_${index}__',
              imagePath: widget.images[index],
            ),
          ),
        ),
      ),
    );
  }
}
