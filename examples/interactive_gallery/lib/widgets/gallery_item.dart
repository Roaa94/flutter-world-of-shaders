import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:interactive_gallery/widgets/gallery_item_page.dart';

class GalleryItem extends StatelessWidget {
  const GalleryItem({
    super.key,
    required this.imagePath,
    required this.heroTag,
    this.heroEnabled = true,
    this.isPage = false,
    this.isAsset = false,
  });

  final String imagePath;
  final String heroTag;
  final bool heroEnabled;
  final bool isPage;
  final bool isAsset;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return HeroMode(
      enabled: heroEnabled,
      child: Hero(
        tag: heroTag,
        child: Container(
          margin: const EdgeInsets.all(3),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SizedBox(
            width: screenSize.width,
            height: screenSize.height,
            child: isAsset
                ? Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  )
                : CachedNetworkImage(
                    imageUrl: imagePath,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }
}
