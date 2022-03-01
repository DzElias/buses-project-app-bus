import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:geolocator/geolocator.dart';

class GpsAccessPage extends StatefulWidget {
  const GpsAccessPage({Key? key}) : super(key: key);

  @override
  State<GpsAccessPage> createState() => _GpsAccessPageState();
}

class _GpsAccessPageState extends State<GpsAccessPage>
    with WidgetsBindingObserver {
  late StreamSubscription<ServiceStatus> serviceStatusStream;
  bool locationStatus = false;

  @override
  void initState() {
    serviceStatusStream = Geolocator.getServiceStatusStream()
        .listen((ServiceStatus status) async {
      print(status);
      if (status == ServiceStatus.enabled) {
        setState(() {
          locationStatus = true;
        });
        if (await permission.Permission.location.isGranted && locationStatus) {
          accesoGPS(permission.PermissionStatus.granted);
        }
      } else {
        setState(() {
          locationStatus = false;
        });
      }
    });
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed && (locationStatus = true)) {
      final status = await permission.Permission.location.isGranted;
      if (status) {
        Navigator.pushReplacementNamed(context, 'nearby-bus-stop-page');
      }
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
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Image(
                  image: AssetImage('assets/draw_location.png'),
                  width: 300,
                  height: 300),
              const Text('¿Donde te encuentras?',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w500)),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 300,
                child: const Text(
                  'Configura tu ubicacion para que podamos brindarte una mejor experiencia',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1.5,
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 60),
              MaterialButton(
                shape: const StadiumBorder(),
                onPressed: () async {
                  if (!await Geolocator.isLocationServiceEnabled()) {
                    Geolocator.openLocationSettings();
                  } else {
                    final status =
                        await permission.Permission.location.request();
                    if (status ==
                        permission.PermissionStatus.permanentlyDenied) {
                      permission.openAppSettings();
                    } else {
                      accesoGPS(status);
                    }
                  }
                },
                color: Colors.blueAccent,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  child: Text(
                    'Establecer automaticamente',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ));
  }

  Future<void> accesoGPS(status) async {
    switch (status) {
      case permission.PermissionStatus.granted:
        if (locationStatus) {
          Navigator.pushReplacementNamed(context, 'nearby-bus-stop-page');
          break;
        }
        break;
      case permission.PermissionStatus.denied:
      case permission.PermissionStatus.restricted:
      case permission.PermissionStatus.permanentlyDenied:
        break;
    }
  }
}
