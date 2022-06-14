// ignore_for_file: constant_identifier_names

import 'package:bustracking/bloc/buses/buses_bloc.dart';
import 'package:bustracking/bloc/map/map_bloc.dart';
import 'package:bustracking/bloc/my_location/my_location_bloc.dart';
import 'package:bustracking/bloc/search/search_bloc.dart';
import 'package:bustracking/bloc/stops/stops_bloc.dart';
import 'package:bustracking/commons/models/stop.dart';
import 'package:bustracking/commons/widgets/bus-stop-marker.dart';
import 'package:bustracking/commons/widgets/my-location-marker.dart';
import 'package:bustracking/pages/nearby-bus-stop-page/widgets/stop_details.dart';
import 'package:bustracking/utils/cachedTileProvider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

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
  int _selectedIndex = 0;

  final _pageController = PageController();
  late final AnimationController animationController;
  // late final MapController mapController;
  List<Marker> markers = [];
   bool reloadMarkers = false;

  @override
  void initState() {
    getFirstLocation();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    animationController.repeat(reverse: true);
    reloadMarkers = false;

    final myLocationBloc = Provider.of<MyLocationBloc>(context, listen: false);
    myLocationBloc.startFollowing();

    // getBusStops();

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  bool manualSelection = false;
 

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    return Scaffold(
      floatingActionButton: !manualSelection ? floatingActionButton() : SizedBox(),
      floatingActionButtonLocation:  FloatingActionButtonLocation.miniEndTop,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          BlocBuilder<MyLocationBloc, MyLocationState>(
            builder: (context, locationState) {
              if (locationState.locationExist) {
                _myLocation = locationState.location!;

                return FlutterMap(
                  options: MapOptions(
                      onMapCreated: (controller) {
                        mapBloc.add(OnMapInitializedEvent(controller));
                      },
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
                        tileProvider: const CachedTileProvider()),
                    MarkerLayerOptions(markers: markers),
                    MarkerLayerOptions(
                      markers: [
                        Marker(
                          height: 60,
                          width: 60,
                          point: LatLng(locationState.location!.latitude,
                              locationState.location!.longitude),
                          builder: (BuildContext context) =>
                              MyLocationMarker(animationController),
                        )
                        // marker
                      ],
                    ),
                  ],
                );
              }
              return SizedBox();
            },
          ),
          BlocBuilder<StopsBloc, StopsState>(
            builder: (context, stopsState) {
              List<Stop> stops = [];
              
              return BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  
                  stops = Provider.of<StopsBloc>(context, listen: false).state.stops;
                  if (stopsState.stops.isNotEmpty) {

                    if(!reloadMarkers){
                      reloadMarkers = true;
                      stops.sort((a, b) => (calculateDistance(LatLng(a.latitud, a.longitud))).compareTo(calculateDistance(LatLng(b.latitud, b.longitud))));
                      createBusStopsMarkers(stops);
                    }

                  }

                  if (state.manualSelection) {
                    manualSelection = true;
                    return Container();
                  }

                  
                  
                  if (stops.isNotEmpty) {
                    return pageView(context, stops);
                  } else {
                    return SizedBox();
                  }
                },
              );
            },
          )
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
        mini: true,
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

  pageView(BuildContext context, List<Stop> busStops) {
    return Positioned(
        left: 0,
        right: 0,
        bottom: 20,
        height: MediaQuery.of(context).size.height * 0.2,
        child: busStops.isNotEmpty
            ? NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overScroll) {
                  overScroll.disallowIndicator();
                  return true;
                },
                child: PageView.builder(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: busStops.length,
                    itemBuilder: (context, i) {
                      final item = busStops[i];
                      int nearestStopIndex = 0;
                      int menDistance = 100000;
                      for (int i = 0; i < busStops.length; i++) {
                        final _item = busStops[i];
                        if (calculateDistance(LatLng(_item.latitud, _item.longitud)) < menDistance) {
                          menDistance = calculateDistance(LatLng(_item.latitud, _item.longitud));
                          nearestStopIndex = i;
                        }
                      }
                      return StopDetails(
                          busStop: item,
                          isNearest: i == nearestStopIndex,
                          distanceInMeters: calculateDistance(LatLng(item.latitud, item.longitud)),
                          time: calculateTime(LatLng(item.latitud, item.longitud)));
                    }),
              )
            : SizedBox());
  }

  createBusStopsMarkers(List<Stop> busStops) {
    List<Marker> _markerList = [];
    markers = [];
    // for (var stop in busStops) {
    for (int i = 0; i < busStops.length; i++) {
      final stop = busStops[i];

      _markerList.add(Marker(
          height: MARKER_SIZE_EXPANDED,
          width: MARKER_SIZE_EXPANDED,
          point: LatLng(stop.latitud, stop.longitud),
          builder: (_) {
            return GestureDetector(
                onTap: () async {
                  _selectedIndex = i;
                  MapController mapController =
                      BlocProvider.of<MapBloc>(context).mapController;
                  animatedMapMove(LatLng(stop.latitud, stop.longitud), mapController.zoom);
                  busStops.isNotEmpty? setState(() {
                    _pageController.animateToPage(i,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut);
                  }): () {};
                },
                child: BusStopMarker(
                  selected: _selectedIndex == i,
                ));
          }));
    }
    markers = _markerList;
    Future.delayed(Duration(seconds: 3)).then((value) {
      setState(() {});
    });
  }

  animatedMapMove(LatLng destLocation, double destZoom) {
    MapController mapController =
        BlocProvider.of<MapBloc>(context).mapController;
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

  void getFirstLocation() async {
    Position? position = await Geolocator.getLastKnownPosition();
    _myLocation = LatLng(position!.latitude, position.longitude);
  }
}
