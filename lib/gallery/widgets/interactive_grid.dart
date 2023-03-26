import 'dart:developer';

import 'package:flutter/material.dart';

typedef InteractiveGridItemBuilder = Widget Function(
  BuildContext context,
  int index,
);

class InteractiveGrid extends StatefulWidget {
  const InteractiveGrid({
    super.key,
    required this.width,
    required this.height,
    required this.itemBuilder,
    this.itemsPerRow = 3,
    this.itemsPerCol = 3,
    this.onScrollStart,
    this.onScrollEnd,
  });

  final double width;
  final double height;
  final InteractiveGridItemBuilder itemBuilder;
  final int itemsPerRow;
  final int itemsPerCol;
  final VoidCallback? onScrollStart;
  final VoidCallback? onScrollEnd;

  @override
  State<InteractiveGrid> createState() => _InteractiveGridState();
}

class _InteractiveGridState extends State<InteractiveGrid>
    with TickerProviderStateMixin {
  final TransformationController _transformationController =
      TransformationController();
  Animation<Matrix4>? _animationReset;
  late final AnimationController _controllerReset;

  void _onAnimateReset() {
    _transformationController.value = _animationReset!.value;
    if (!_controllerReset.isAnimating) {
      _animationReset!.removeListener(_onAnimateReset);
      _animationReset = null;
      _controllerReset.reset();
    }
  }

  void _animateResetInitialize() {
    _controllerReset.reset();
    _animationReset = Matrix4Tween(
      begin: _transformationController.value,
      end: Matrix4.identity(),
    ).animate(_controllerReset);
    _animationReset!.addListener(_onAnimateReset);
    _controllerReset.forward();
  }

// Stop a running reset to home transform animation.
  void _animateResetStop() {
    _controllerReset.stop();
    _animationReset?.removeListener(_onAnimateReset);
    _animationReset = null;
    _controllerReset.reset();
  }

  void _onInteractionStart(ScaleStartDetails details) {
    // If the user tries to cause a transformation while the reset animation is
    // running, cancel the reset animation.
    if (_controllerReset.status == AnimationStatus.forward) {
      _animateResetStop();
    }
    widget.onScrollStart?.call();
  }

  @override
  void initState() {
    super.initState();
    _controllerReset = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _controllerReset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: _transformationController,
      constrained: false,
      scaleEnabled: false,
      onInteractionStart: _onInteractionStart,
      onInteractionUpdate: (details) {
        // log('Updated');
        // log(details.focalPointDelta.toString());
      },
      onInteractionEnd: (details) {
        print('_transformationController.value');
        print(_transformationController.value.getTranslation());
        // log('Ended');
        // log(details.toString());
        // _animateResetInitialize();
        widget.onScrollEnd?.call();
      },
      child: SizedBox(
        width: widget.width * widget.itemsPerRow,
        height: widget.height * widget.itemsPerCol,
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: widget.itemsPerRow,
          childAspectRatio: widget.width / widget.height,
          children: List.generate(
            widget.itemsPerRow * widget.itemsPerCol,
            (index) => widget.itemBuilder(context, index),
          ),
        ),
      ),
    );
  }
}
