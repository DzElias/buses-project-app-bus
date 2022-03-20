import 'dart:convert';

import 'package:bustracking/commons/models/bus.dart';
import 'package:http/http.dart';

class BusService {
  Future<List<Bus>> getBuses() async {
    List<Bus> buses = [];
    final response =
        await get(Uri.parse('https://milab-cde.herokuapp.com/coordenadas/bus'));
    List<Bus> busesToAdd = [];
    List data = jsonDecode(response.body);
    for (var singleBus in data) {
      Bus bus = Bus.fromJson(singleBus);
      // if (bus.activo) {
      busesToAdd.add(bus);
      // }
    }
    buses = busesToAdd;
    return buses;
  }
}
