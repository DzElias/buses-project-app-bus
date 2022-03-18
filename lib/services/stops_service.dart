import 'dart:convert';

import 'package:bustracking/commons/models/busStop.dart';
import 'package:bustracking/services/places_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart';

import '../commons/models/places_response.dart';
import 'package:latlong2/latlong.dart';

class StopService {
  Future<List<BusStop>> getStops() async {
    final response = await get(
        Uri.parse('https://pruebas-socket.herokuapp.com/coordenadas'));
    List data = jsonDecode(response.body);
    List<BusStop> busStops = [];

    for (var singleBusStop in data) {
      BusStop busStop = (BusStop(
          id: singleBusStop['_id'],
          title: singleBusStop['titulo'],
          location: LatLng(singleBusStop['latitud'].toDouble(),
              singleBusStop['longitud'].toDouble()),
          adress: singleBusStop['direccion'],
          imageLink: singleBusStop['imagen']));
      busStops.add(busStop);
    }
    return busStops;

    // busStops.sort((a, b) => (calculateDistance(a.location))
    //     .compareTo(calculateDistance(b.location)));
  }
}
