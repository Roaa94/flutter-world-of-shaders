import 'dart:developer';

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

class _InteractiveGridState extends State<InteractiveGrid> {
  Duration _animationDuration = Duration.zero;
  Offset _gridOffset = Offset.zero;

  void _onScaleStart(ScaleStartDetails details) {
    print(_gridOffset);
    widget.onScrollStart?.call();
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    // print('Scale');
    // print(details.localFocalPoint);
    var newOffset = _gridOffset + details.focalPointDelta;
    print(newOffset);
    setState(() {
      _gridOffset = newOffset.clamp(
        Offset(
          -(widget.gridWidth - widget.viewportWidth),
          -(widget.gridHeight - widget.viewportHeight),
        ),
        Offset.zero,
      );
    });
  }

  Future<void> _onScaleEnd(ScaleEndDetails details) async {
    final pannedViewportsCountX =
        (_gridOffset.dx / widget.viewportWidth).round();
    final pannedViewportsCountY =
        (_gridOffset.dy / widget.viewportHeight).round();

    // Todo: change duration based on velocity
    // print(details.velocity);
    _animationDuration = const Duration(milliseconds: 300);

    setState(() {
      _gridOffset = Offset(
        pannedViewportsCountX * widget.viewportWidth,
        pannedViewportsCountY * widget.viewportHeight,
      );
    });
    widget.onScrollEnd?.call();
    await Future<dynamic>.delayed(_animationDuration);
    _animationDuration = Duration.zero;
  }

  @override
  void initState() {
    log('Viewport Dimensions: '
        '(${widget.viewportWidth}, ${widget.viewportHeight})');
    log('Grid Dimensions: (${widget.gridWidth}, ${widget.gridHeight})');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      onScaleEnd: _onScaleEnd,
      child: OverflowBox(
        maxHeight: double.infinity,
        maxWidth: double.infinity,
        alignment: Alignment.topLeft,
        child: TweenAnimationBuilder(
          duration: _animationDuration,
          tween: Tween<Offset>(begin: Offset.zero, end: _gridOffset),
          builder: (context, Offset offset, Widget? child) {
            return Transform(
              transform: Matrix4.identity()
                ..setTranslationRaw(offset.dx, offset.dy, 0),
              child: SizedBox(
                width: widget.gridWidth,
                height: widget.gridHeight,
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: widget.itemsPerRow,
                  childAspectRatio:
                      widget.viewportWidth / widget.viewportHeight,
                  children: List.generate(
                    widget.itemsPerRow * widget.itemsPerCol,
                    (index) => widget.itemBuilder(context, index),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

extension ClampOffset on Offset {
  Offset clamp(Offset lowerLimit, Offset upperLimit) {
    return Offset(
      dx.clamp(lowerLimit.dx, upperLimit.dx),
      dy.clamp(lowerLimit.dy, upperLimit.dy),
    );
  }
}
