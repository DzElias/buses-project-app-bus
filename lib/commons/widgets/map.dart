import 'dart:convert';

import 'package:bustracking/bloc/my_location/my_location_bloc.dart';
import 'package:bustracking/commons/models/busStop.dart';
import 'package:bustracking/commons/widgets/bus-stop-marker.dart';
import 'package:bustracking/helpers/cachedTileProvider.dart';
import 'package:bustracking/pages/bus-stop-page/models/walking_route.dart';
import 'package:bustracking/pages/nearby-bus-stop-page/widgets/stop_details.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';

import 'my-location-marker.dart';

const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoiZWxpYXNkaWF6MTAwNSIsImEiOiJja3d4eDQ3OTcwaHk3Mm51cjNmcWRvZjA2In0.AAF794oxyxFR_-wAvVwMfQ';
const MAPBOX_STYLE = 'mapbox/light-v10';
const MARKER_COLOR = Colors.blueAccent;
const MARKER_SIZE_EXPANDED = 60.0;
const MARKER_SIZE_SHRINKED = 40.0;

class MapWidget extends StatefulWidget {
  bool showStops;
  LatLng? busStopLatLng;
  List<Marker> markers = [];
  String busRoute = '';

  MapWidget(
      {Key? key,
      this.showStops = false,
      this.busStopLatLng,
      required this.markers,
      required this.busRoute})
      : super(key: key);

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<MapWidget> with TickerProviderStateMixin {
  List<BusStop> busStops = [];
  int _selectedIndex = 0;
  List<LatLng> rutaCoords = [];

  late final AnimationController animationController;
  final MapController mapController = MapController();

  @override
  void initState() {
    final myLocationBloc = Provider.of<MyLocationBloc>(context, listen: false);

    if (!widget.showStops) {
      crear_ruta_a_parada(myLocationBloc.state.location!, widget.busStopLatLng);
    }

    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    animationController.repeat(reverse: true);

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myLocationBloc = Provider.of<MyLocationBloc>(context, listen: false);
    LatLng? lastLocation = myLocationBloc.state.location;

    final points = polylinePoints.decodePolyline("zdhso@`lpggBrtEevQkEeo@tv@i|ChVW`yOpwEobHrwXyoOm|Ey@q@");

    return Scaffold(
        floatingActionButton: widget.showStops ? floatingActionButton(context) : SizedBox(),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
        body: Stack(
          children: [
            BlocBuilder<MyLocationBloc, MyLocationState>(builder: (context, state) => showMap(state, lastLocation, context)),
          ],
        ));
  }

  floatingActionButton(BuildContext context) {
    return BlocBuilder<MyLocationBloc, MyLocationState>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.only(top: 150, right: 20),
          child: FloatingActionButton(
            mini: true,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.my_location,
              color: Colors.blueAccent,
            ),
            onPressed: () {
              animatedMapMove(
                  LatLng(state.location!.latitude, state.location!.longitude),
                  16);
            },
          ),
        );
      },
    );
  }

  Widget showMap(MyLocationState state, LatLng? lastLocation, BuildContext context) {
    if (!state.locationExist) {
      return Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    }

    Polyline _rutaParada =  Polyline(points: rutaCoords, strokeWidth: 6, color: Colors.blue, isDotted: true);
    final points = widget.busRoute.isNotEmpty ? polylinePoints.decodePolyline(widget.busRoute) : [];

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
          center: lastLocation,
          minZoom: 5,
          zoom: 16,
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
        points.isNotEmpty ? PolylineLayerOptions(
          polylines: [
                Polyline(
                    strokeWidth: 3.0,
                    color: Colors.blue,
                    points: points
                        .map((point) => LatLng(point.latitude / 10, point.longitude / 10))
                        .toList())
              ])
            : PolylineLayerOptions(),
        PolylineLayerOptions(
          polylines: [_rutaParada],
        ),
        // MarkerLayerOptions(markers: markers),
        MarkerLayerOptions(markers: widget.markers),
        MarkerLayerOptions(
          markers: [
            Marker(
              height: 60,
              width: 60,
              point:
                  LatLng(state.location!.latitude, state.location!.longitude),
              builder: (BuildContext context) =>
                  MyLocationMarker(animationController),
            ),
            !widget.showStops
                ? Marker(
                    height: MARKER_SIZE_EXPANDED,
                    width: MARKER_SIZE_EXPANDED,
                    point: widget.busStopLatLng!,
                    builder: (context) {
                      return GestureDetector(
                          onTap: () async {
                            animatedMapMove(
                                widget.busStopLatLng!, mapController.zoom);
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
                : Marker(point: LatLng(0, 0), builder: (_) => SizedBox())
            // marker
          ],
        ),
        
      ],
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

  Future crear_ruta_a_parada(LatLng? inicio, LatLng? destino) async {
    final url =
        '${baseUrl}/mapbox/walking/${inicio!.longitude},${inicio.latitude};${destino!.longitude},${destino.latitude}';

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

      animatedMapMove(destino, 15);
      // rutaCoords[((rutaCoords.length) / 2).round()]
    });
  }

  calculateDistance(LatLng point) {
    final myLocationBloc = Provider.of<MyLocationBloc>(context, listen: false);
    LatLng? lastLocation = myLocationBloc.state.location;
    var myLocation = lastLocation;

    var _distanceInMeters = Geolocator.distanceBetween(point.latitude,
        point.longitude, myLocation!.latitude, myLocation.longitude);

    int distance = _distanceInMeters.round();

    return distance;
  }

  calculateTime(LatLng point) {
    String time;
    int hours = 0;
    int distance = calculateDistance(point);
    int minutes = (((distance / 1000) * 60) / 4).round();
    while (minutes > 60) {
      hours = hours + 1;
      minutes = minutes - 60;
    }
    if (hours == 0) {
      time = '${minutes} min';
      return time;
    } else {
      time = "${hours} h ${minutes} min";
      return time;
    }
  }
}
