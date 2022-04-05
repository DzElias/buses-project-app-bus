// You can pass any object to the arguments parameter.
// In this example, create a class that contains both
// a customizable title and message.

import 'package:bustracking/commons/models/bus.dart';
import 'package:bustracking/commons/models/busStop.dart';
import 'package:latlong2/latlong.dart';

class BusPageArguments {
  final Bus bus;
  final BusStop stop;

  BusPageArguments({
    required this.bus,
    required this.stop,
  });
}
