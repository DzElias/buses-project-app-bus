// You can pass any object to the arguments parameter.
// In this example, create a class that contains both
// a customizable title and message.

import 'package:latlong2/latlong.dart';

class BusPageArguments {
  final String busId;
  //quitar cuando se pueda rastrear a bus
  final LatLng busLocation;
  final String busName;
  final String linea;
  final List<dynamic> paradas;
  final String primeraParada;
  final String ultimaParada;
  final String proximaParada;
  final LatLng busStopLatLng;
  

  BusPageArguments(this.busId, this.busLocation, this.busName, this.linea, this.paradas, this.primeraParada, this.ultimaParada, this.proximaParada, this.busStopLatLng);
}