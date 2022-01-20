import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:bustracking/commons/models/busStop.dart';
import 'package:bustracking/commons/widgets/bus-stop-marker.dart';
import 'package:bustracking/helpers/cachedTileProvider.dart';
import 'package:bustracking/pages/nearby-bus-stop-page/widgets/custom-card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:cached_network_image/cached_network_image.dart';

const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoiZWxpYXNkaWF6MTAwNSIsImEiOiJja3d4eDQ3OTcwaHk3Mm51cjNmcWRvZjA2In0.AAF794oxyxFR_-wAvVwMfQ';
const MAPBOX_STYLE = 'mapbox/light-v10';
const MARKER_COLOR = Colors.blueAccent;
const MARKER_SIZE_EXPANDED = 60.0;
const MARKER_SIZE_SHRINKED = 40.0;

class NearbyBusStopsMap extends StatefulWidget {
  const NearbyBusStopsMap({Key? key}) : super(key: key);

  @override
  State<NearbyBusStopsMap> createState() => _NearbyBusStopsMapState();
}

class _NearbyBusStopsMapState extends State<NearbyBusStopsMap>
    with TickerProviderStateMixin {
  LatLng _myLocation = LatLng(-25.4978575, -54.6789153);
  List<BusStop> busStops = [];
  int _selectedIndex = 0;
  List<Marker> markers = [];

  final _pageController = PageController();
  late final AnimationController animationController;
  late final MapController mapController;

  @override
  void initState() {
    mapController = MapController();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    animationController.repeat(reverse: true);
    super.initState();
    getBusStops();
  }

  @override
  void dispose() {
    animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
                center: _myLocation,
                minZoom: 5,
                zoom: 16,
                maxZoom: 18,
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
                   tileProvider: const CachedTileProvider()
                  ),
                 
              MarkerLayerOptions(markers: markers),
              MarkerLayerOptions(
                markers: [
                  Marker(
                    height: 60,
                    width: 60,
                    point: _myLocation,
                    builder: (BuildContext context) =>
                        MyLocationMarker(animationController),
                  )
                  // marker
                ],
              ),
            ],
          ),
          pageView(context)
        ],
      ),
    );
  }

  calculateDistance(LatLng point) {
    //TODO: si es menor a mil pasar metros y si es mas pasar a km y redondear
    var _distanceInMeters = Geolocator.distanceBetween(point.latitude,
        point.longitude, _myLocation.latitude, _myLocation.longitude);

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

  floatingActionButton() {
    return Container(
      margin: EdgeInsets.only(top: 150, right: 20),
      child: FloatingActionButton(

        mini:true,
        
        backgroundColor: Colors.white,
        child: Icon(
          Icons.my_location,
          color: Colors.blueAccent,
        ),
        onPressed: () {
          animatedMapMove(_myLocation, 16);
        },
      ),
    );
  }

  pageView(BuildContext context) {
    return Positioned(
        left: 0,
        right: 0,
        bottom: 20,
        height: MediaQuery.of(context).size.height * 0.3,
        child: busStops.isNotEmpty ? NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overScroll) {
                  overScroll.disallowGlow();
                  return true;
                },
                child: PageView.builder(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: busStops.length,
                    itemBuilder: (context, index) {
                      final item = busStops[index];
                      int nearestStopIndex = 0;
                      int menDistance = 100000;
                      for (int i = 0; i < busStops.length; i++) {
                        print(i);
                        final _item = busStops[i];
                        if (calculateDistance(_item.location) < menDistance) {
                          menDistance = calculateDistance(_item.location);
                          nearestStopIndex = i;
                        }
                      }
                      return _StopDetails(
                        myLocation: _myLocation,
                          busStop: item,
                          isNearest: index == nearestStopIndex,
                          distanceInMeters: calculateDistance(item.location),
                          time: calculateTime(item.location));
                    }),
              )
            : SizedBox());
  }

  getBusStops() async {
    final response =
        await get(Uri.parse('https://milab-cde.herokuapp.com/coordenadas'));
    List data = jsonDecode(response.body);

    for (var singleBusStop in data) {
      BusStop busStop = (BusStop(
          id: singleBusStop['_id'],
          title: singleBusStop['titulo'],
          location: LatLng(singleBusStop['latitud'].toDouble(), singleBusStop['longitud'].toDouble()),
          adress: singleBusStop['direccion'],
          imageLink: singleBusStop['imagen']));
      busStops.add(busStop);
    }
    busStops.sort((a, b) => (calculateDistance(a.location))
        .compareTo(calculateDistance(b.location)));
    createBusStopsMarkers();
  }

  createBusStopsMarkers() {
    final _markerList = <Marker>[];

    for (int i = 0; i < busStops.length; i++) {
      final mapItem = busStops[i];
      _markerList.add(
        Marker(
          height: MARKER_SIZE_EXPANDED,
          width: MARKER_SIZE_EXPANDED,
          point: mapItem.location,
          builder: (_) {
            return GestureDetector(
                onTap: () async {
                  _selectedIndex = i;

                  animatedMapMove(mapItem.location, mapController.zoom);
                  busStops.isNotEmpty ? setState(() {
                          _pageController.animateToPage(i,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeOut);
                        })
                      : () {};
                },
                // child: Icon(Icons.place),
                child: BusStopMarker(
                  selected: _selectedIndex == i,
                ));
          }));
    }
    setState(() {
      markers = _markerList;
    });
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
}



class MyLocationMarker extends AnimatedWidget {
  const MyLocationMarker(Animation<double> animation, {Key? key})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final value = (listenable as Animation<double>).value;
    final newValue = lerpDouble(0.7, 1.0, value)!;
    final size = 25;
    return Center(
      child: Stack(
        children: [
          Center(
            child: Container(
              height: size * newValue,
              width: size * newValue,
              decoration: BoxDecoration(
                  color: MARKER_COLOR.withOpacity(0.3), shape: BoxShape.circle),
            ),
          ),
          Center(
            child: Container(
              height: 15,
              width: 15,
              decoration:
                  BoxDecoration(color: MARKER_COLOR, shape: BoxShape.circle),
            ),
          ),
        ],
      ),
    );
  }
}

class _StopDetails extends StatelessWidget {
  final BusStop busStop;
  final bool isNearest;
  final int distanceInMeters;
  final String time;
  final LatLng myLocation;
  const _StopDetails(
      {Key? key,
      required this.distanceInMeters,
      required this.busStop,
      required this.time,
      required this.myLocation,
      
      this.isNearest = false, })
      : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: CustomCard(
          stopLatLng: busStop.location,
          isNearest: isNearest,
          stopName: busStop.title,
          distance: (distanceInMeters > 1000)
              ? '${(distanceInMeters / 1000).round()} Km '
              : '${distanceInMeters} m ',
          time: '(${time})',
          imageLink: busStop.imageLink,
          stopAdress: busStop.adress,
          myLocation: myLocation,
        ));
  }
}

