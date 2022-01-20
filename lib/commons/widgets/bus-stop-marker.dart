import 'package:flutter/material.dart';
const MARKER_SIZE_EXPANDED = 60.0;
const MARKER_SIZE_SHRINKED = 40.0;
class BusStopMarker extends StatelessWidget {
  const BusStopMarker({Key? key, this.selected = false}) : super(key: key);
  final bool selected;
  @override
  Widget build(BuildContext context) {
    final size = selected ? MARKER_SIZE_EXPANDED : MARKER_SIZE_SHRINKED;
    return Center(
        child: AnimatedContainer(
            height: size,
            width: size,
            duration: Duration(milliseconds: 300),
            child: Image(image: AssetImage('assets/busStop.png'))));
  }
}