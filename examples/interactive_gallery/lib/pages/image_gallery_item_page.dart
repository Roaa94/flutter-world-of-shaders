import 'package:flutter/material.dart';
import 'package:interactive_gallery/widgets/image_gallery_item.dart';
import 'package:interactive_gallery/widgets/interactive_grid.dart';

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
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapUp: (_) {
          Navigator.of(context).pop();
        },
        child: InteractiveGrid(
          viewportSize: screenSize,
          crossAxisCount: 4,
          initialIndex: widget.initialIndex,
          onChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          children: List.generate(
            widget.images.length,
            (index) => ImageGalleryItem(
              heroTag: '__hero_${index}__',
              imagePath: widget.images[index],
              heroEnabled: index == currentIndex,
            ),
          ),
        ),
      ),
    );
  }
}
