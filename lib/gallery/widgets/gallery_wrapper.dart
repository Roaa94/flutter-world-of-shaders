import 'package:flutter/material.dart';
import 'package:flutter_world_of_shaders/effects/fisheye_distortion.dart';
import 'package:flutter_world_of_shaders/gallery/widgets/gallery_grid.dart';
import 'package:flutter_world_of_shaders/gallery/widgets/interactive_grid.dart';

class GalleryWrapper extends StatefulWidget {
  const GalleryWrapper({super.key});

  @override
  State<GalleryWrapper> createState() => _GalleryWrapperState();
}

class _GalleryWrapperState extends State<GalleryWrapper>
    with SingleTickerProviderStateMixin {
  final _distortionAmountNotifier = ValueNotifier<double>(0);
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      precacheImage(
        Image.asset('assets/gallery/trevi-fountain-thumb.png').image,
        context,
      );
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return ValueListenableBuilder(
      valueListenable: _distortionAmountNotifier,
      builder: (context, double distortionAmount, Widget? child) {
        return TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: distortionAmount),
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 500),
          builder: (context, double distortionAmount, Widget? child) {
            return FisheyeDistortion(
              distortionAmount: distortionAmount,
              child: child!,
            );
          },
          child: child,
        );
      },
      child: InteractiveGrid(
        viewportWidth: screenSize.width,
        viewportHeight: screenSize.height,
        onScrollStart: () {
          _distortionAmountNotifier.value = 0.9;
        },
        onScrollEnd: () {
          _distortionAmountNotifier.value = 0.0;
        },
        children: List.generate(
          9,
          (index) => const GalleryGrid(),
        ),
      ),
    );
  }
}
