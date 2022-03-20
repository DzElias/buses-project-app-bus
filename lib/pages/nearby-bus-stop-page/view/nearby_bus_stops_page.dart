import 'dart:async';

import 'package:bustracking/bloc/buses/buses_bloc.dart';
import 'package:bustracking/bloc/my_location/my_location_bloc.dart';
import 'package:bustracking/bloc/search/search_bloc.dart';
import 'package:bustracking/bloc/stops/stops_bloc.dart';
import 'package:bustracking/commons/models/busStop.dart';
import 'package:bustracking/pages/nearby-bus-stop-page/widgets/manual_marker.dart';
import 'package:bustracking/pages/nearby-bus-stop-page/widgets/nearby_bus_stops_map.dart';

import 'package:bustracking/commons/widgets/custom-appbar.dart';
import 'package:bustracking/commons/widgets/main_drawer.dart';
import 'package:bustracking/pages/nearby-bus-stop-page/widgets/search_bar.dart';
import 'package:bustracking/services/socket_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:provider/provider.dart';

// ignore: constant_identifier_names
const MARKER_SIZE_EXPANDED = 60.0;
// ignore: constant_identifier_names
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

  @override
  void initState() {
    final busesBloc = Provider.of<BusesBloc>(context, listen: false);
    busesBloc.getBuses();
    final stopsBloc = Provider.of<StopsBloc>(context, listen: false);
    stopsBloc.getStops();

    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.connect();
    socketService.socket
        .on('change-locationReturn', busesBloc.handleBusLocation);

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
                  children: const [NearbyBusStopsMap(), ManualMarker()],
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
              if (snapshot.hasData) {
                return BlocBuilder<MyLocationBloc, MyLocationState>(
                  builder: (context, state) {
                    return Stack(
                      children: const [
                        NearbyBusStopsMap(),
                        SearchBar(),
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
      Position? position = await Geolocator.getCurrentPosition();
      myLocation = LatLng(position.latitude, position.longitude);

      return 'GPS Activo';
    }
  }
}
