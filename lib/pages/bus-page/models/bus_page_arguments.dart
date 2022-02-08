// You can pass any object to the arguments parameter.
// In this example, create a class that contains both
// a customizable title and message.

import 'package:bustracking/commons/models/bus.dart';
import 'package:latlong2/latlong.dart';

class BusPageArguments {
  final Bus bus;
  final LatLng busStopLatLng;
  final String busStopName;
  

  BusPageArguments({
    required this.bus, 
    required this.busStopName,
    required this.busStopLatLng
  });
}