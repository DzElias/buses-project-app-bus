
import 'dart:ui';

import 'package:flutter/material.dart';

const MARKER_COLOR = Colors.blueAccent;

class MyLocationMarker extends AnimatedWidget {
  const MyLocationMarker(Animation<double> animation, {Key? key})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final value = (listenable as Animation<double>).value;
    final newValue = lerpDouble(0.7, 1.0, value)!;
    final size = 25;
    return Center(
      child: Stack(
        children: [
          Center(
            child: Container(
              height: size * newValue,
              width: size * newValue,
              decoration: BoxDecoration(
                  color: MARKER_COLOR.withOpacity(0.3), shape: BoxShape.circle),
            ),
          ),
          Center(
            child: Container(
              height: 15,
              width: 15,
              decoration:
                  BoxDecoration(color: MARKER_COLOR, shape: BoxShape.circle),
            ),
          ),
        ],
      ),
    );
  }
}