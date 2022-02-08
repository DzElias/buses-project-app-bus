import 'dart:convert';

import 'package:bustracking/commons/models/bus.dart';
import 'package:bustracking/commons/widgets/custom-appbar.dart';

import 'package:bustracking/commons/widgets/main_drawer.dart';
import 'package:bustracking/helpers/cachedTileProvider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';

const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoiZWxpYXNkaWF6MTAwNSIsImEiOiJja3d4eDQ3OTcwaHk3Mm51cjNmcWRvZjA2In0.AAF794oxyxFR_-wAvVwMfQ';
const MAPBOX_STYLE = 'mapbox/light-v10';

class SearchBus extends StatefulWidget {
  @override
  State<SearchBus> createState() => _SearchBusState();
}

class _SearchBusState extends State<SearchBus> {
  @override
  void initState() {
    getActiveBuses();
    super.initState();
  }

  List<Marker> busMarkers = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: const CustomAppBar(
          title: Text(
            'Buscar Buses',
            style: TextStyle(
                fontSize: 17,
                color: Colors.black87,
                fontFamily: 'Betm-Medium',
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        drawer: MainDrawer(),
        body: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                  center: LatLng(-25.5161428, -54.6418963),
                  zoom: 12,
                  minZoom: 6,
                  maxZoom: 16,
                  interactiveFlags:
                      InteractiveFlag.all & ~InteractiveFlag.rotate),
              layers: [
                TileLayerOptions(
                    urlTemplate:
                        "https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}",
                    additionalOptions: {
                      'accessToken': MAPBOX_ACCESS_TOKEN,
                      'id': MAPBOX_STYLE
                    },
                    tileProvider: const CachedTileProvider()),
                MarkerLayerOptions(markers: busMarkers),
              ],
            ),
            searchBusContainer(),
          ],
        ));
  }

  Container searchBusContainer() {
    return Container(
      margin: const EdgeInsets.only(top: 90),
      child: Align(
        alignment: Alignment.topCenter,
        child: ElevatedButton(
          onPressed: () {
            //TODO abrir buscador de buses
          },
          child: SizedBox(
            width: 300,
            height: 60,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.directions_bus, color: Colors.green),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '¿Que bus estas buscando?',
                        style: TextStyle(
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.my_location,
                    color: Colors.black45,
                  )
                ]),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
          ),
        ),
      ),
    );
  }

  getActiveBuses() async {
    List<Bus> buses = await generateBusList();
    List<Marker> markerList = [];
    for (var bus in buses) {
      markerList.add(
        Marker(
          point: LatLng(bus.latitud, bus.longitud),
          key: Key(bus.id),
          builder: (_) => const Center(
                  child: Image(
                    image: AssetImage('assets/bus_point.png'),
                    
                  ))));
    }
    setState(() {
      busMarkers = markerList;
    });
  }

  generateBusList() async {
    final response =
        await get(Uri.parse('https://milab-cde.herokuapp.com/coordenadas/bus'));
    List<Bus> buses = [];
    List data = jsonDecode(response.body);
    for (var singleBus in data) {
      Bus bus = Bus.fromJson(singleBus);
      buses.add(bus);
    }
    return buses;
  }
}
