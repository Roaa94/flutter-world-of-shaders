import 'package:flutter/material.dart';
import 'package:flutter_world_of_shaders/gallery/widgets/interactive_gallery.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final List<String> images = [
    'assets/gallery/paris-01.jpeg',
    'assets/gallery/paris-02.jpeg',
    'assets/gallery/paris-03.jpeg',
    'assets/gallery/paris-04.jpeg',
    'assets/gallery/paris-05.jpeg',
    'assets/gallery/paris-06.jpeg',
    'assets/gallery/paris-07.jpeg',
    'assets/gallery/paris-08.jpeg',
    'assets/gallery/paris-09.jpeg',
    'assets/gallery/paris-10.jpeg',
    'assets/gallery/paris-11.jpeg',
    'assets/gallery/paris-12.jpeg',
    'assets/gallery/paris-13.jpeg',
    'assets/gallery/paris-14.jpeg',
    'assets/gallery/paris-15.jpeg',
    'assets/gallery/paris-16.jpeg',
    'assets/gallery/paris-17.jpeg',
    'assets/gallery/paris-18.jpeg',
    'assets/gallery/paris-19.jpeg',
    'assets/gallery/paris-20.jpeg',
    'assets/gallery/paris-21.jpeg',
    'assets/gallery/paris-22.jpeg',
    'assets/gallery/paris-23.jpeg',
    'assets/gallery/paris-24.jpeg',
    'assets/gallery/paris-25.jpeg',
    'assets/gallery/florence-01.jpeg',
    'assets/gallery/florence-02.jpeg',
    'assets/gallery/florence-03.jpeg',
    'assets/gallery/florence-04.jpeg',
    'assets/gallery/florence-05.jpeg',
    'assets/gallery/florence-06.jpeg',
    'assets/gallery/florence-07.jpeg',
    'assets/gallery/florence-08.jpeg',
    'assets/gallery/florence-09.jpeg',
    'assets/gallery/florence-10.jpeg',
    'assets/gallery/florence-11.jpeg',
    'assets/gallery/florence-12.jpeg',
    'assets/gallery/florence-13.jpeg',
    'assets/gallery/florence-14.jpeg',
    'assets/gallery/florence-15.jpeg',
  ];

  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      print(ImageCache().maximumSizeBytes);
      for (final image in images) {
        precacheImage(Image.asset(image).image, context);
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: InteractiveGallery(
        images: images,
      ),
    );
  }
}
