import 'package:flutter/material.dart';
import 'package:interactive_gallery/effects/pincushion_distortion.dart';

class PincushionDistortionPage extends StatelessWidget {
  const PincushionDistortionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FisheyeDistortionWrapper(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.asset(
            'assets/bricks.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class FisheyeDistortionWrapper extends StatefulWidget {
  const FisheyeDistortionWrapper({
    super.key,
    required this.child,
    this.power = 0.2,
  });

  final Widget child;
  final double power;

  @override
  State<FisheyeDistortionWrapper> createState() =>
      _FisheyeDistortionWrapperState();
}

class _FisheyeDistortionWrapperState extends State<FisheyeDistortionWrapper> {
  double distortion = 1;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PincushionDistortion(
          distortionAmount: distortion,
          child: widget.child,
        ),
        Positioned(
          bottom: 10,
          left: 10,
          right: 10,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Slider(
              activeColor: Colors.white,
              value: distortion,
              divisions: 200,
              onChanged: (value) {
                setState(() {
                  distortion = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
