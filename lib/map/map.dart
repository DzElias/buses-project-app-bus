import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';

import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  void initState() {
    
    super.initState();
    // getLastLocation();
    
  }

  MapController mapController = MapController();
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(center: LatLng(-25.513475, -54.615440), zoom: 18.0, maxZoom: 18, minZoom: 16),
      layers: [
        TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']),
        MarkerLayerOptions(
          markers: [],
        ),
      ],
    );
  }

  getLastLocation() async {
    Position? lastKnowPosition = await Geolocator.getLastKnownPosition(
        forceAndroidLocationManager: true);
    mapController.move(LatLng(lastKnowPosition!.latitude, lastKnowPosition.longitude), mapController.zoom);
  }
}
