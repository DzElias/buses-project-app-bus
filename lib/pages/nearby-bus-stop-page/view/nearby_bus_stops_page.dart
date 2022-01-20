import 'dart:async';

import 'package:bustracking/pages/nearby-bus-stop-page/widgets/nearby_bus_stops_map.dart';

import 'package:bustracking/pages/nearby-bus-stop-page/widgets/custom-card.dart';
import 'package:bustracking/commons/widgets/custom-appbar.dart';
import 'package:bustracking/commons/widgets/main_drawer.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import 'package:permission_handler/permission_handler.dart' as permission;

class NearbyBusStopPage extends StatefulWidget {
  const NearbyBusStopPage({Key? key}) : super(key: key);

  @override
  State<NearbyBusStopPage> createState() => _NearbyBusStopPageState();
}

class _NearbyBusStopPageState extends State<NearbyBusStopPage>
    with WidgetsBindingObserver {
      late StreamSubscription<ServiceStatus > serviceStatusStream;
  @override
  void initState() {
    
    WidgetsBinding.instance?.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
        checkGpsAccess(context);
    
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print(state);
    print(ModalRoute.of(context)!.settings.name);
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
     serviceStatusStream =  Geolocator.getServiceStatusStream().listen(
    (ServiceStatus status) {
      print(status);
      if (status == ServiceStatus.disabled){
        Navigator.pushReplacementNamed(context, 'gps-access-page');
      }
    });
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
            return Stack(
              children: [
                NearbyBusStopsMap(),
                addDestinationButton(),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          }
        },
      ),
    );
  }

  addDestinationButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(
            top: 90,
          ),
          child: ElevatedButton(
            onPressed: () {
              //Enviar datos de parada
              Navigator.pushNamed(context, 'add-destination');
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
}

Future checkGpsAccess(BuildContext context) async {
  bool permisoGPS = await permission.Permission.location.isGranted;
  final gpsActivo = await Geolocator.isLocationServiceEnabled();
  
  if (!permisoGPS | !gpsActivo) {
    await Future.delayed(Duration(milliseconds: 1000));
    Navigator.pushReplacementNamed(context, 'gps-access-page');
  } else {
    return 'GPS Activo';
  }
}
