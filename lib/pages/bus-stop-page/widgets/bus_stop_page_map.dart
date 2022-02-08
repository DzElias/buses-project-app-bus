import 'dart:convert';

import 'package:bustracking/commons/models/bus.dart';
import 'package:bustracking/commons/models/busStop.dart';
import 'package:bustracking/commons/widgets/bus-stop-marker.dart';
import 'package:bustracking/commons/widgets/my-location-marker.dart';
import 'package:bustracking/helpers/cachedTileProvider.dart';
import 'package:bustracking/pages/bus-stop-page/models/walking_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:dio/dio.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart';

import 'package:latlong2/latlong.dart';

const MAPBOX_ACCESS_TOKEN = 'pk.eyJ1IjoiZWxpYXNkaWF6MTAwNSIsImEiOiJja3d4eDQ3OTcwaHk3Mm51cjNmcWRvZjA2In0.AAF794oxyxFR_-wAvVwMfQ';
const MAPBOX_STYLE = 'mapbox/light-v10';
const MARKER_COLOR = Colors.blueAccent;
const MARKER_SIZE_EXPANDED = 60.0;
const MARKER_SIZE_SHRINKED = 40.0;

class BusStopPageMap extends StatefulWidget {
  final LatLng myLocation;
  final LatLng busStopLatLng;
  final List<Marker> extraMarkers;
  final bool busRoute;

  const BusStopPageMap(
      {Key? key,
      required this.myLocation,
      required this.busStopLatLng,
      required this.extraMarkers,
      this.busRoute = false})
      : super(key: key);

  @override
  State<BusStopPageMap> createState() => _BusStopPageMapState();
}

class _BusStopPageMapState extends State<BusStopPageMap>
    with TickerProviderStateMixin {
  late final AnimationController animationController;
  late MapController mapController;
  List<LatLng> rutaCoords = [];
  List<Marker> markers = [];

  @override
  void initState() {
    crear_ruta_a_parada(widget.myLocation, widget.busStopLatLng);
    mapController = MapController();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    animationController.repeat(reverse: true);
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Polyline _rutaParada = Polyline(
        points: rutaCoords, strokeWidth: 4, color: Colors.blue, isDotted: true);
    final points = polylinePoints.decodePolyline(
        "zdhso@`lpggBrtEevQkEeo@tv@i|ChVW`yOpwEobHrwXyoOm|Ey@q@");

    return Scaffold(
      floatingActionButton: floatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      body: FlutterMap(
          mapController: mapController,
          options: MapOptions(
              center: widget.myLocation,
              minZoom: 5,
              zoom: 14,
              maxZoom: 18,
              interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate),
          layers: [
            TileLayerOptions(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}",
                additionalOptions: {
                  'accessToken': MAPBOX_ACCESS_TOKEN,
                  'id': MAPBOX_STYLE
                },
                tileProvider: const CachedTileProvider()),
            MarkerLayerOptions(markers: widget.extraMarkers),
            MarkerLayerOptions(markers: markers),
            MarkerLayerOptions(
              markers: [
                Marker(
                  height: 60,
                  width: 60,
                  point: widget.myLocation,
                  builder: (BuildContext context) =>
                      MyLocationMarker(animationController),
                ),
                Marker(
                    height: MARKER_SIZE_EXPANDED,
                    width: MARKER_SIZE_EXPANDED,
                    point: widget.busStopLatLng,
                    builder: (_) {
                      return GestureDetector(
                          onTap: () async {
                            animatedMapMove(
                                widget.busStopLatLng, mapController.zoom);
                          },
                          // child: Icon(Icons.place),
                          child: Center(
                              child: Container(
                            child: Image(
                              image: AssetImage('assets/busStop.png'),
                            ),
                            height: MARKER_SIZE_EXPANDED,
                            width: MARKER_SIZE_EXPANDED,
                          )));
                    })
                // marker
              ],
            ),
            PolylineLayerOptions(
              polylines: [_rutaParada],
            ),
            widget.busRoute
                ? PolylineLayerOptions(polylines: [
                    Polyline(
                        strokeWidth: 3.0,
                        color: Colors.blueAccent,
                        points: points
                            .map((point) => LatLng(
                                point.latitude / 10, point.longitude / 10))
                            .toList())
                  ])
                : PolylineLayerOptions()
          ]),
    );
  }

  floatingActionButton() {
    return FloatingActionButton(
      mini: true,
      backgroundColor: Colors.white,
      child: Icon(
        Icons.my_location,
        color: Colors.blueAccent,
      ),
      onPressed: () {
        animatedMapMove(widget.myLocation, 16);
      },
    );
  }

  animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final _latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final _lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final _zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
          LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),
          _zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  final baseUrl = 'https://api.mapbox.com/directions/v5';
  final _dio = new Dio();
  PolylinePoints polylinePoints = PolylinePoints();

  Future crear_ruta_a_parada(LatLng inicio, LatLng destino) async {
    final url =
        '${baseUrl}/mapbox/walking/${inicio.longitude},${inicio.latitude};${destino.longitude},${destino.latitude}';

    final resp = await this._dio.get(url, queryParameters: {
      'alternatives': 'false',
      'geometries': 'polyline6',
      'steps': 'false',
      'access_token': MAPBOX_ACCESS_TOKEN,
      'language': 'es',
    });

    final data = WalkingRoute.fromJson(resp.data);
    final geometry = data.routes[0].geometry;
    final duracion = data.routes[0].duration;
    final distancia = data.routes[0].distance;
    final points = polylinePoints.decodePolyline(geometry);

    setState(() {
      rutaCoords = points
          .map((point) => LatLng(point.latitude / 10, point.longitude / 10))
          .toList();
      if (rutaCoords.isNotEmpty) {
        animatedMapMove(destino, 15);
        // rutaCoords[((rutaCoords.length) / 2).round()]
      }
    });
  }

  getBuses() async {
    final response =
        await get(Uri.parse('https://milab-cde.herokuapp.com/coordenadas/bus'));
    List data = jsonDecode(response.body);
    List<Bus> buses = [];
    for (var singleBus in data) {
      Bus bus = Bus.fromJson(singleBus);
    }

    final _markerList = <Marker>[];
    for (int i = 0; i < buses.length; i++) {
      final mapItem = buses[i];
      _markerList.add(Marker(
          point: LatLng(mapItem.latitud, mapItem.longitud),
          builder: (BuildContext context) {
            return Center(
                //agregar imagen de bus
                );
          }));
    }
  }
}
