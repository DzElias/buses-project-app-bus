// ignore_for_file: must_be_immutable

import 'package:bustracking/bloc/map/map_bloc.dart';
import 'package:bustracking/bloc/my_location/my_location_bloc.dart';
import 'package:bustracking/bloc/stops/stops_bloc.dart';
import 'package:bustracking/commons/models/stop.dart';
import 'package:bustracking/commons/widgets/bus-stop-marker.dart';
import 'package:bustracking/pages/bus-stop-page/models/walking_route.dart';
import 'package:bustracking/utils/cachedTileProvider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';

import 'my-location-marker.dart';

const MAPBOX_ACCESS_TOKEN = 'pk.eyJ1IjoiZWxpYXNkaWF6MTAwNSIsImEiOiJja3o4c3Nla20xbnBrMnBwMTN4cXpuOGYxIn0.wfniiVLrGVbimAqr_OKyMg';
const MAPBOX_STYLE = 'mapbox/light-v10';
const MARKER_COLOR = Colors.blueAccent;
const MARKER_SIZE_EXPANDED = 60.0;
const MARKER_SIZE_SHRINKED = 40.0;

class MapWidget extends StatefulWidget {
  LatLng? busStopLatLng;
  List<Marker> markers = [];
  List<String> selectedStops = [];
  String busRoute = '';
  LatLng destino2;
  bool viajando;

  MapWidget(
      {Key? key,

      this.busStopLatLng,
      required this.selectedStops,
      required this.destino2,
      required this.markers,
      required this.busRoute,
      required this.viajando
      
      })
      : super(key: key);

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<MapWidget> with TickerProviderStateMixin {
  List<Stop> busStops = [];
  List<LatLng> rutaCoords = [];
  List<LatLng> rutaCoords2 = [];

  late final AnimationController animationController;
  final MapController mapController = MapController();

  @override
  void initState() {
    final myLocationBloc = Provider.of<MyLocationBloc>(context, listen: false);

    
    crear_ruta_a_parada(myLocationBloc.state.location!, widget.selectedStops, widget.destino2);
    

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

    if(widget.viajando){
      rutaCoords = [];
    }

    if(rutaCoords2.isNotEmpty){
      if(calculateDistance(rutaCoords2.last)<10 ){
      rutaCoords2 = [];
      }
    }

    if(rutaCoords.isNotEmpty){
      if(calculateDistance(rutaCoords.last)<10 ){
      rutaCoords = [];
      }
    }


    return Scaffold(
        floatingActionButton: floatingActionButton(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
        body: Stack(
          children: [
            BlocBuilder<MyLocationBloc, MyLocationState>(
                builder: (context, state) =>
                    showMap(state, lastLocation, context)),
          ],
        ));
  }

  floatingActionButton(BuildContext context) {
    return !widget.viajando? BlocBuilder<MyLocationBloc, MyLocationState>(
      builder: (context, state) {
        return Container(
          margin: widget.busRoute.isNotEmpty ? EdgeInsets.only(top: 70, right: 20) : EdgeInsets.only(top: 20, right: 20) ,
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
                  18);
            },
          ),
        );
      },
    ) : SizedBox();
  }

  Widget showMap(MyLocationState state, LatLng? lastLocation, BuildContext context) {
    if (!state.locationExist) {
      return Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    }

    Polyline _rutaParada = Polyline( points: rutaCoords, strokeWidth: 6, color: Colors.blue, isDotted: true);
    Polyline _rutaParada2 = Polyline( points: rutaCoords2, strokeWidth: 6, color: Colors.blue, isDotted: true);
    final points = widget.busRoute.isNotEmpty? polylinePoints.decodePolyline(widget.busRoute): [];

    final mapBloc = BlocProvider.of<MapBloc>(context);

    return BlocBuilder<StopsBloc, StopsState>(
      builder: (context, stopsState) {
         List stops = stopsState.stops;
        return FlutterMap(
          mapController: mapController,
          options: MapOptions(
              onMapCreated: (controller) {
                mapBloc.add(OnMap2InitializedEvent(controller));
              },
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
            points.isNotEmpty
                ? PolylineLayerOptions(polylines: [
                    Polyline(
                        strokeWidth: 3.0,
                        color: Colors.green,
                        points: points
                            .map((point) => LatLng(
                                point.latitude / 10, point.longitude / 10))
                            .toList())
                  ])
                : PolylineLayerOptions(),
            PolylineLayerOptions(
              polylines: [_rutaParada, _rutaParada2],
            ),
            // MarkerLayerOptions(markers: markers),
            !widget.viajando? MarkerLayerOptions(
              markers: [
                Marker(
                  height: 60,
                  width: 60,
                  point: LatLng(state.location!.latitude, state.location!.longitude),
                  builder: (BuildContext context) =>MyLocationMarker(animationController),
                ),
              ],
            ): MarkerLayerOptions(
              markers: []
            ),
            MarkerLayerOptions(
             markers: buildMarkers(stops)
            ),

            (widget.selectedStops.length > 1) ? 
            MarkerLayerOptions
            (
              markers:
              [
                Marker(
                  point: widget.destino2, 
                  height: 40,
                  width: 40,
                  builder: (BuildContext context) => GestureDetector(child: Icon( Icons.location_on_rounded, size: 40, color: Colors.blue,),
                  
                  )
                
                )    
              ]
            ) 
            : MarkerLayerOptions(),
            
            MarkerLayerOptions(markers: widget.markers),
          ],
        );
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
  var _dio = new Dio();
  PolylinePoints polylinePoints = PolylinePoints();

  Future crear_ruta_a_parada(LatLng? inicio, List<String> stops, LatLng destino2) async {
    final stopsBloc = Provider.of<StopsBloc>(context, listen: false);
    final i = stopsBloc.state.stops.indexWhere((element) => element.id == stops[0]);

    LatLng destino = LatLng(stopsBloc.state.stops[i].latitud, stopsBloc.state.stops[i].longitud);

    var url ='${baseUrl}/mapbox/walking/${inicio!.longitude},${inicio.latitude};${destino.longitude},${destino.latitude}';

    final resp = await this._dio.get(url, queryParameters: {
      'alternatives': 'false',
      'geometries': 'polyline6',
      'steps': 'false',
      'access_token': MAPBOX_ACCESS_TOKEN,
      'language': 'es',
    });

    final data = WalkingRoute.fromJson(resp.data);
    final geometry = data.routes[0].geometry;
    final points = polylinePoints.decodePolyline(geometry);

    if(stops.length > 1)
    {
     final index = stopsBloc.state.stops.indexWhere((element) => element.id == stops[1]);
     destino = LatLng(stopsBloc.state.stops[index].latitud, stopsBloc.state.stops[index].longitud);

      url ='${baseUrl}/mapbox/walking/${destino.longitude},${destino.latitude};${destino2.longitude},${destino2.latitude}';
      _dio = new Dio();
      final resp2 = await this._dio.get(url, queryParameters: {
      'alternatives': 'false',
      'geometries': 'polyline6',
      'steps': 'false',
      'access_token': MAPBOX_ACCESS_TOKEN,
      'language': 'es',
    });

    final data2 = WalkingRoute.fromJson(resp2.data);
    final geometry2 = data2.routes[0].geometry;
    final points2 = polylinePoints.decodePolyline(geometry2);

    setState(() {
      rutaCoords2 = points2
          .map((point) => LatLng(point.latitude / 10, point.longitude / 10))
          .toList();     // rutaCoords[((rutaCoords.length) / 2).round()]
    });


    }

    setState(() {
      rutaCoords = points.map((point) => LatLng(point.latitude / 10, point.longitude / 10)).toList();

      animatedMapMove(inicio, 18);
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
  
  List<Marker> buildMarkers(List stops) {
  if(stops.isEmpty){
    return [];
  }

  List<Marker> _markerList = [];

  for(int i=0; i<stops.length; i++ ){
    Stop stop = stops[i];
    bool _selected = false;
    for(String id in widget.selectedStops){
      if(id == stop.id){
        _selected = true;
      }
    }
    _markerList.add(Marker(
          height: MARKER_SIZE_EXPANDED,
          width: MARKER_SIZE_EXPANDED,
          point: LatLng(stop.latitud, stop.longitud),
          builder: (_) {
            return BusStopMarker(selected: _selected);
          }));
  }
  
  return _markerList;
}
}


