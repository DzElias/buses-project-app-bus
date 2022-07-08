import 'package:flutter/material.dart';
class StopMarker extends StatelessWidget {
  const StopMarker({Key? key, this.selected = false}) : super(key: key);
  final bool selected;
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 60,
        width: 60,
        child:  Image(image: AssetImage('assets/images/stop.png'))
      )
    );
  }
}