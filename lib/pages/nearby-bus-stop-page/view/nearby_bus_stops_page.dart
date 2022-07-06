import 'dart:async';

import 'package:user_app/bloc/buses/buses_bloc.dart';
import 'package:user_app/bloc/my_location/my_location_bloc.dart';
import 'package:user_app/bloc/search/search_bloc.dart';
import 'package:user_app/bloc/stops/stops_bloc.dart';
import 'package:user_app/bloc/travel/travel_bloc.dart';
import 'package:user_app/commons/widgets/main_drawer.dart';
import 'package:user_app/pages/bus-page/models/bus_page_arguments.dart';
import 'package:user_app/pages/nearby-bus-stop-page/widgets/manual_marker.dart';
import 'package:user_app/pages/nearby-bus-stop-page/widgets/nearby_bus_stops_map.dart';

import 'package:user_app/commons/widgets/custom-appbar.dart';
import 'package:user_app/pages/nearby-bus-stop-page/widgets/search_bar.dart';
import 'package:user_app/services/socket_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
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
    WidgetsBinding.instance.addObserver(this);


    Future.delayed(Duration.zero, () {
      initialization();
    });
    
    final travelBloc = Provider.of<TravelBloc>(context, listen: false);
    if(travelBloc.state.traveling || travelBloc.state.waiting){
        Navigator.pushNamed(context, "bus-page", arguments: BusPageArguments(bus: travelBloc.state.bus!, stop: travelBloc.state.stop!, stopsSelected: travelBloc.state.stopsSelected, waiting: travelBloc.state.waiting, destino: travelBloc.state.destino!));
    }

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark
      )
    );

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
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    serviceStatusStream = Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
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
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text(
             'Paradas de Buses',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black87,
                  fontFamily: 'Betm-Medium',
                  fontWeight: FontWeight.bold
                ),
            ),
          ),
          drawer: MainDrawer(),
          body: FutureBuilder(
            future: checkGpsAccess(context),
            builder: (BuildContext context, AsyncSnapshot snapshot) 
            {
              if (snapshot.hasData) 
              {
                return BlocBuilder<MyLocationBloc, MyLocationState>(
                  builder: (context, state) 
                  {
                    return Stack(
                      children:
                      [
                        NearbyBusStopsMap(),
                        SearchBar(),
                       
                      ],
                    );
                  },
                );
              } else 
              {
                return const Center(child: CircularProgressIndicator(strokeWidth: 2,),);
              }
            },
          ),
        );
      },
    );
  }

  initialization()async {
    final locationBloc = Provider.of<MyLocationBloc>(context, listen: false);
    final stopsBloc = Provider.of<StopsBloc>(context, listen: false);
    if(locationBloc.state.sw){
      stopsBloc.state.stops.sort((a, b) => (calculateDistance(LatLng(a.latitude, a.longitude))).compareTo(calculateDistance(LatLng(b.latitude, b.longitude))));
    }else{
    final busesBloc = Provider.of<BusesBloc>(context, listen: false);
    final socket = Provider.of<SocketService>(context, listen: false).socket;

    socket.connect();
    socket.on('loadBuses', busesBloc.loadBuses);
    socket.on('loadStops', stopsBloc.loadStops);
    socket.on('change-locationReturn', busesBloc.handleBusLocation);
    socket.on('changeNextStopReturn', busesBloc.handleBusProxStop);

    

    await Future.delayed(Duration(seconds: 3));

    FlutterNativeSplash.remove();
    }
    
  }
   calculateDistance(LatLng point) async{
    Position position = await Geolocator.getCurrentPosition();
    LatLng _myLocation = LatLng(position.latitude, position.longitude);
    //TODO: si es menor a mil pasar metros y si es mas pasar a km y redondear
    var _distanceInMeters = Geolocator.distanceBetween(point.latitude,
        point.longitude, _myLocation.latitude, _myLocation.longitude);

    int distance = _distanceInMeters.round();
    return distance;
  }

  checkGpsAccess(BuildContext context) async 
  {
    bool permisoGPS = await permission.Permission.location.isGranted;
    final gpsActivo = await Geolocator.isLocationServiceEnabled();

    if (!permisoGPS | !gpsActivo) 
    {
      await Future.delayed(const Duration(milliseconds: 1000));
      Navigator.pushReplacementNamed(context, 'gps-access-page');
    }else 
    {

      Position? position = await Geolocator.getCurrentPosition();
      myLocation = LatLng(position.latitude, position.longitude);

      return 'GPS Activo';
    }
  }
}
