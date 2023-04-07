import 'package:flutter/material.dart';

extension OffsetExtension on Offset {
  Offset clamp(Offset lowerLimit, Offset upperLimit) {
    return Offset(
      dx.clamp(lowerLimit.dx, upperLimit.dx),
      dy.clamp(lowerLimit.dy, upperLimit.dy),
    );
  }

  Offset ceil() {
    return Offset(dx.ceilToDouble(), dy.ceilToDouble());
  }

  Offset floor() {
    return Offset(dx.floorToDouble(), dy.floorToDouble());
  }

  Offset round() {
    return Offset(dx.roundToDouble(), dy.roundToDouble());
  }

  Offset floorOrCeil(Offset delta, {double tolerance = 0}) {
    final dTolerance = Offset(
      delta.dx.abs() / delta.dx * tolerance,
      delta.dy.abs() / delta.dy * tolerance,
    );

    return Offset(
      delta.dx < dTolerance.dx ? dx.floorToDouble() : dx.ceilToDouble(),
      delta.dy < dTolerance.dy ? dy.floorToDouble() : dy.ceilToDouble(),
    );
  }
}
