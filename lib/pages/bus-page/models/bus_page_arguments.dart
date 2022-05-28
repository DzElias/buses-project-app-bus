// You can pass any object to the arguments parameter.
// In this example, create a class that contains both
// a customizable title and message.

import 'package:bustracking/commons/models/bus.dart';
import 'package:bustracking/commons/models/stop.dart';
import 'package:latlong2/latlong.dart';

class BusPageArguments {
  final Bus bus;
  final Stop stop;
  bool waiting = false;
  List<String> stopsSelected = [];
  final LatLng destino;

  BusPageArguments({
    required this.destino, 
    required this.waiting, 
    required this.bus,
    required this.stop,
    required this.stopsSelected
  });
}
