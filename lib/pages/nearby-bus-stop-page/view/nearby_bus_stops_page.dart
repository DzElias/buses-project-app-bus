import 'dart:async';

import 'package:bustracking/bloc/my_location/my_location_bloc.dart';
import 'package:bustracking/bloc/search/search_bloc.dart';
import 'package:bustracking/commons/models/busStop.dart';
import 'package:bustracking/commons/models/search_destination_result.dart';
import 'package:bustracking/pages/nearby-bus-stop-page/widgets/manual_marker.dart';
import 'package:bustracking/pages/nearby-bus-stop-page/widgets/nearby_bus_stops_map.dart';

import 'package:bustracking/commons/widgets/custom-appbar.dart';
import 'package:bustracking/commons/widgets/main_drawer.dart';
import 'package:bustracking/search/search_destination.dart';
import 'package:bustracking/search/search_destination.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:provider/provider.dart';

const MARKER_SIZE_EXPANDED = 60.0;
const MARKER_SIZE_SHRINKED = 40.0;

class NearbyBusStopPage extends StatefulWidget {
  const NearbyBusStopPage({Key? key}) : super(key: key);

  @override
  State<NearbyBusStopPage> createState() => _NearbyBusStopPageState();
}

class _NearbyBusStopPageState extends State<NearbyBusStopPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late StreamSubscription<ServiceStatus> serviceStatusStream;

  LatLng myLocation = LatLng(0, 0);

  List<BusStop> busStops = [];
  List<Marker> markers = [];

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));

    checkGpsAccess(context);

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      checkGpsAccess(context);
    }
  }

  @override
  void dispose() {
    serviceStatusStream.cancel();
    WidgetsBinding.instance?.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    serviceStatusStream =
        Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
      if (status == ServiceStatus.disabled) {
        Navigator.pushReplacementNamed(context, 'gps-access-page');
      }
    });

    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state.manualSelection) {
          return BlocBuilder<MyLocationBloc, MyLocationState>(
            builder: (context, myLocationstate) {
              return Scaffold(
                body: Stack(
                children: [
                  NearbyBusStopsMap(),
                  ManualMarker()
                  
                ],
              ),
              );
            },
          );
        }
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: const CustomAppBar(
            centerTitle: true,
            title: Text(
              'Paradas de Buses Cercanas',
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.black87,
                  fontFamily: 'Betm-Medium',
                  fontWeight: FontWeight.bold),
            ),
          ),
          drawer: MainDrawer(),
          body: FutureBuilder(
            future: checkGpsAccess(context),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              print(snapshot.data);
              if (snapshot.hasData) {
                return BlocBuilder<MyLocationBloc, MyLocationState>(
                  builder: (context, state) {
                    return Stack(
                      children: [
                        NearbyBusStopsMap(),
                        SearchBar(),

                       
                        // pageView(context)
                      ],
                    );
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }



  checkGpsAccess(BuildContext context) async {
    bool permisoGPS = await permission.Permission.location.isGranted;
    final gpsActivo = await Geolocator.isLocationServiceEnabled();

    if (!permisoGPS | !gpsActivo) {
      await Future.delayed(const Duration(milliseconds: 1000));
      Navigator.pushReplacementNamed(context, 'gps-access-page');
    } else {
      Position? position = await Geolocator.getLastKnownPosition();
      myLocation = LatLng(position!.latitude, position.longitude);

      return 'GPS Activo';
    }
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(
            top: 90,
          ),
          child: ElevatedButton(
            onPressed: () async {
              final locationBloc = Provider.of<MyLocationBloc>(context, listen: false);
              final proximity = locationBloc.state.location;
              final searchResult = await showSearch(
                  context: context, delegate: SearchDestination(proximity!));
              searchReturn(context, searchResult);
            },
            child: Container(
              width: 300,
              height: 50,
              child: Row(children: const [
                Icon(
                  Icons.location_pin,
                  color: Colors.blueAccent,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Toca para agregar destino',
                  style: TextStyle(
                    color: Colors.black45,
                  ),
                ),
              ]),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  void searchReturn(BuildContext context, SearchDestinationResult? result) {
    // print('cancel: ${result!.cancel}');
    // print('manual: ${result!.manual}');
    if (result!.cancel) return;
    if (result.manual) {
      final searchBloc = Provider.of<SearchBloc>(context, listen: false);
      searchBloc.add(OnEnableManualMarker());
    }
  }
}
