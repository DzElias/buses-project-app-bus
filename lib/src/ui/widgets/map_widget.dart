import 'dart:async';
import 'package:intl/intl.dart';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:latlong2/latlong.dart';
import 'package:me_voy_chofer/src/data/services/socket_service.dart';
import 'package:me_voy_chofer/src/domain/blocs/bus/bus_bloc.dart';
import 'package:me_voy_chofer/src/domain/blocs/bus_travel/bus_travel_bloc.dart';
import 'package:me_voy_chofer/src/domain/blocs/stop/stop_bloc.dart';
import 'package:me_voy_chofer/src/domain/blocs/user_location/user_location_bloc.dart';
import 'package:me_voy_chofer/src/domain/entities/bus.dart';
import 'package:me_voy_chofer/src/domain/entities/stop.dart';
import 'package:me_voy_chofer/src/ui/widgets/stop_marker.dart';
import 'package:me_voy_chofer/src/utils/cachedTileProvider.dart';
import 'package:me_voy_chofer/src/utils/map_utils.dart';
import 'package:me_voy_chofer/src/utils/matrix.dart';
import 'package:provider/provider.dart';

const mapboxAccessToken =
  'pk.eyJ1IjoiZWxpYXNkaWF6MTAwNSIsImEiOiJjbDUxdGpveGUwOHhzM2pwajZjNWVjaHYwIn0.aFD-rLHhe8R-vYYh3OYHKw';

class MapWidget extends StatefulWidget {
  MapWidget({
    Key? key, 
    required this.busId, 
    required this.mapController, required this.busRoute, 
  }) : super(key: key);

  final String busId;
  MapController mapController;
  final String busRoute;
  

  @override
  State<MapWidget> createState() => _MapWidgetState();
}



class _MapWidgetState extends State<MapWidget> with TickerProviderStateMixin{
  late String _timeString;
  
  

  @override
  void initState() {
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  @override
  void dispose() {
    widget.mapController.dispose();
    super.dispose();
  }
   

  @override
  Widget build(BuildContext context) {
    MapController mapController2 = widget.mapController;
    Polyline busRoutePolyline = Polyline(
      strokeWidth: 6,
      color: Colors.deepPurpleAccent.shade400,
      points: PolylinePoints()
        .decodePolyline(widget.busRoute)
        .map((e) => LatLng(e.latitude / 10, e.longitude / 10))
        .toList()
    );


    return BlocBuilder<UserLocationBloc, UserLocationState>(
      builder: (context, userLocationState) {
        if(userLocationState is UserLocationLoaded){
          LatLng userLocation = LatLng(userLocationState.latitude, userLocationState.longitude);
          return Container(
            margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * .32),
            child: Stack(
              children: [
                FlutterMap(
                  mapController: mapController2,
                  options: MapOptions(
                  center: userLocation,
                  rotation: 2.0,
                  minZoom: 5,
                  zoom: 16.5,
                  maxZoom: 18,
                  interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                  onMapCreated: (controller){
                    mapController2 = controller;
                  }
                ),
                  layers: [
                  TileLayerOptions(
                    urlTemplate:
                        'https://api.mapbox.com/styles/v1/eliasdiaz1005/cl51kvpz3001914laj756j70g/tiles/256/{z}/{x}/{y}@2x?access_token={access_token}',
                    additionalOptions: {
                      "access_token": mapboxAccessToken
                    },
                    tileProvider: const CachedTileProvider()
                  ),
                  

                  PolylineLayerOptions(
                    polylines: [busRoutePolyline]
                  ),
                  MarkerLayerOptions(
                    markers: createStopsMarkers()
                  ),
                  MarkerLayerOptions(
                    markers: [
                      Marker(
                        height: 60,
                        width: 60,
                        point: userLocation,
                        builder: (_) => const Center(
                          child: Image(
                            image: AssetImage(
                              'assets/images/bus_point.png'),
                              height: 60,
                            ),
                        )
                      )
                    ]
                  )
                ],
                  children: [
                    BlocBuilder<BusTravelBloc, BusTravelState>(
                      builder: (context, state) {
                        if(state is BusIsTravelingState){
                          return TravelBuilder(busId: widget.busId, mapController: widget.mapController, tickerProvider: this);
                        }
                        return Container();
                      },
                    )
                    
                  ],
                
                ),
                Positioned(
                  top: 40,
                  right: 20,
                  child: GestureDetector(
                    onTap: (){
                      
                      MapUtils().animatedMapMove(userLocation, 16.5, this, widget.mapController);
                      
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.deepPurpleAccent.shade400
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.my_location, 
                          color: Colors.white,
                          size: 32,
                        )
                      ),
                    ),
                  ),
                ),

                // Positioned(
                //   bottom: 0,
                //   right: 10,
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color: Colors.white,
                //       borderRadius: const  BorderRadius.only(
                //         topLeft: Radius.circular(10), 
                //         topRight: Radius.circular(10)
                //       ),
                //       boxShadow: [
                //         BoxShadow(
                //           blurRadius: 5.0,
                //           offset: Offset(0, 0),
                //           color: Colors.deepPurpleAccent.shade400
                //         ),
                //       ],
                //     ),                    
                //     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),

                //     child: Text(_timeString, style: TextStyle(
                //       color: Colors.deepPurpleAccent.shade400,
                //       fontSize: 20,
                //       fontWeight: FontWeight.w500
                //     ))
                //   ),
                // )
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  List<Marker> createStopsMarkers(){
    List<Stop> stops = (Provider.of<StopBloc>(context, listen: false).state as StopsLoadedState).stops;

    List<Marker> markers = stops.map((stop) {
      return Marker(
        height: 60,
        width: 60,
        point: LatLng(stop.latitude, stop.longitude),
        builder: (_) => const StopMarker()
      );
    }).toList();

    return markers;

  }
  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MM/dd/yyyy hh:mm:ss').format(dateTime);
  }
}

class TravelBuilder extends StatefulWidget {
  TravelBuilder({
    Key? key, required this.busId, required this.mapController, required this.tickerProvider,
  }) : super(key: key);
  final String busId;
  MapController mapController;
  final TickerProvider tickerProvider;

  @override
  State<TravelBuilder> createState() => _TravelBuilderState();
}

class _TravelBuilderState extends State<TravelBuilder> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StopBloc, StopState>(
      builder: (context, stopstate) {
        return BlocBuilder<BusBloc, BusState>(
          builder: (context, bustate) {
            return BlocBuilder<UserLocationBloc, UserLocationState>(
              builder: (context, userLocationState) {
                var userLocationStateLoaded = userLocationState as UserLocationLoaded; 
                LatLng busLocation = LatLng(userLocationStateLoaded.latitude, userLocationStateLoaded.longitude);
                Bus bus = (bustate as BusesLoadedState).buses.firstWhere((element) => element.id == widget.busId); 
                Stop actualNextStop = (stopstate as StopsLoadedState).stops.firstWhere((e) => e.id == bus.nextStop);
                MapUtils().animatedMapMove(busLocation, 16.5, widget.tickerProvider, widget.mapController);

                if(Matrix().calculateDistanceInMeters(busLocation, LatLng(actualNextStop.latitude, actualNextStop.longitude) ) < 50){
                  Future.delayed(Duration.zero).then((value) {
                    String nextStopId = getNextStop(widget.busId);
                    Provider.of<SocketService>(context, listen: false).socket.emit('change-nextStop', [[bus.id, nextStopId]]);
                  });
                }

                return Container();
              },
            );
          },
        );
      },
    );
  }
  String getNextStop(String busId) {
    final bustate = Provider.of<BusBloc>(context, listen: false).state;
    final stopstate = Provider.of<StopBloc>(context, listen: false).state;
    List<Stop> stops = (stopstate as StopsLoadedState).stops;

    Bus bus = (bustate as BusesLoadedState).buses.firstWhere((element) => element.id == busId); 
    int actualNextStopIdIndex = bus.stops.indexWhere((e) => e == bus.nextStop);
    int nextStopIndex = actualNextStopIdIndex + 1;
    if(nextStopIndex >= bus.stops.length){
      nextStopIndex = 0;
    } 
    String nextStopId = bus.stops[nextStopIndex];
    return nextStopId; 
  }

}

