import 'dart:convert';

import 'package:bustracking/commons/models/bus.dart';
import 'package:bustracking/commons/models/stop.dart';
import 'package:http/http.dart';

import 'package:latlong2/latlong.dart';

class StopService {
  Future<List<Stop>> getStops() async {
    final response = await get(Uri.parse('https://pruebas-socket.herokuapp.com/coordenadas'));
    List data = jsonDecode(response.body);
    List<Stop> busStops = [];
    for (var singleBusStop in data) {
      Stop busStop = Stop.fromJson(singleBusStop);
      busStops.add(busStop);
    }
    return busStops;
  }
}
