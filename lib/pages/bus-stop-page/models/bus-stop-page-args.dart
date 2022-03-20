// You can pass any object to the arguments parameter.
// In this example, create a class that contains both
// a customizable title and message.

import 'package:latlong2/latlong.dart';

class BusStopPageArguments {
  final String busStopName;

  final String busStopAdress;
  final String time;
  final LatLng busStopLatLng;
  final String stopId;
  BusStopPageArguments(this.busStopName, this.busStopAdress, this.time,
      this.busStopLatLng, this.stopId);
}
