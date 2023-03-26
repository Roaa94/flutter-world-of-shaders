import 'package:flutter/material.dart';

typedef InteractiveGridItemBuilder = Widget Function(
  BuildContext context,
  int index,
);

class InteractiveGrid extends StatefulWidget {
  const InteractiveGrid({
    super.key,
    required this.viewportWidth,
    required this.viewportHeight,
    required this.itemBuilder,
    this.itemsPerRow = 3,
    this.itemsPerCol = 3,
    this.onScrollStart,
    this.onScrollEnd,
  });

  final double viewportWidth;
  final double viewportHeight;
  final InteractiveGridItemBuilder itemBuilder;
  final int itemsPerRow;
  final int itemsPerCol;
  final VoidCallback? onScrollStart;
  final VoidCallback? onScrollEnd;

  double get gridWidth => viewportWidth * itemsPerRow;

  double get gridHeight => viewportHeight * itemsPerCol;

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

  void _snapToGridItem() {
    final currentOffset = _transformationController.value.getTranslation();

    final pannedViewportsCountX =
        (currentOffset.x / widget.viewportWidth).round();
    final pannedViewportsCountY =
        (currentOffset.y / widget.viewportHeight).round();

    _controllerReset.reset();
    _animationReset = Matrix4Tween(
      begin: _transformationController.value,
      end: Matrix4.identity()
        ..setTranslationRaw(
          pannedViewportsCountX * widget.viewportWidth,
          pannedViewportsCountY * widget.viewportHeight,
          0,
        ),
    ).animate(
      CurvedAnimation(
        parent: _controllerReset,
        curve: Curves.easeOut,
      ),
    );

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
        // log(details.toString());
      },
      onInteractionEnd: (details) {
        _snapToGridItem();
        widget.onScrollEnd?.call();
      },
      child: SizedBox(
        width: widget.gridWidth,
        height: widget.gridHeight,
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: widget.itemsPerRow,
          childAspectRatio: widget.viewportWidth / widget.viewportHeight,
          children: List.generate(
            widget.itemsPerRow * widget.itemsPerCol,
            (index) => widget.itemBuilder(context, index),
          ),
        ),
      ),
    );
  }
}
