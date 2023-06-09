import 'package:core/core.dart';
import 'package:flutter/material.dart';

class PincushionDistortionPage extends StatelessWidget {
  const PincushionDistortionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PincushionDistortionWrapper(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: GridView.count(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: 10,
              top: MediaQuery.of(context).padding.top,
            ),
            crossAxisCount: 5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: List.generate(
              70,
              (index) => Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PincushionDistortionWrapper extends StatefulWidget {
  const PincushionDistortionWrapper({
    super.key,
    required this.child,
    this.power = 0.2,
  });

  final Widget child;
  final double power;

  @override
  State<PincushionDistortionWrapper> createState() =>
      _PincushionDistortionWrapperState();
}

class _PincushionDistortionWrapperState
    extends State<PincushionDistortionWrapper> {
  double distortion = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PincushionDistortion(
          distortionAmount: distortion,
          child: widget.child,
        ),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(10),
            child: Slider(
              activeColor: Colors.white,
              inactiveColor: Colors.white.withOpacity(0.5),
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
