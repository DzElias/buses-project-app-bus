import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:me_voy_chofer/src/data/services/socket_service.dart';
import 'package:me_voy_chofer/src/domain/blocs/bus_travel/bus_travel_bloc.dart';
import 'package:me_voy_chofer/src/domain/blocs/internet_connection/internet_connection_bloc.dart';
import 'package:me_voy_chofer/src/domain/blocs/stop/stop_bloc.dart';
import 'package:me_voy_chofer/src/domain/blocs/user_location/user_location_bloc.dart';
import 'package:me_voy_chofer/src/domain/entities/bus.dart';
import 'package:me_voy_chofer/src/ui/pages/navigation-page/widgets/bus_side_bar.dart';
import 'package:me_voy_chofer/src/ui/pages/navigation-page/widgets/main_drawer.dart';
import 'package:me_voy_chofer/src/ui/widgets/map_widget.dart';
import 'package:me_voy_chofer/src/utils/show_alert.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class NavigationPage extends StatefulWidget {
  NavigationPage({Key? key, required this.bus}) : super(key: key);
  final Bus bus;

  MapController mapController = MapController();

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    var socket = Provider.of<SocketService>(context, listen: false).socket;
    socket.on(
        'loadStops',
        (data) => Provider.of<StopBloc>(context, listen: false)
            .add(SaveStopsEvent(data)));
    socket.emit('change-nextStop', [
      [widget.bus.id, widget.bus.firstStop]
    ]);
    Provider.of<InternetConnectionBloc>(context, listen: false)
        .add(StartListenInternetConnection());
    Provider.of<UserLocationBloc>(context, listen: false)
        .add(StartFollowingEvent());
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    StreamSubscription? subscription;
    if (state == AppLifecycleState.paused) {
      var travelState =
          Provider.of<BusTravelBloc>(context, listen: false).state;
      if (travelState is BusIsTravelingState) {
        const geoLocatorOptions = LocationSettings(
            accuracy: LocationAccuracy.high, distanceFilter: 20);
        Position? position;
        subscription =
            Geolocator.getPositionStream(locationSettings: geoLocatorOptions)
                .listen((Position _position) {
          var socket =
              Provider.of<SocketService>(context, listen: false).socket;
          socket.emit('change-location', [
            [widget.bus.id, _position.latitude, _position.longitude]
          ]);
          position = _position;
        });
      }
    }
    if ((state == AppLifecycleState.resumed) && (subscription != null)) {
      subscription.cancel();
      subscription = null;
    }
  }

  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          // drawer: MainDrawer(),
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(color: Colors.black, size: 40),
            elevation: 0,
          ),
          body: BlocBuilder<UserLocationBloc, UserLocationState>(
            builder: (context, userLocationState) {
              if (userLocationState is UserLocationLoaded) {
                return Stack(
                  children: [
                    MapWidget(
                        busId: widget.bus.id,
                        mapController: widget.mapController,
                        busRoute: widget.bus.ruta),
                    // BusSideBar(bus: widget.bus),
                    BlocBuilder<BusTravelBloc, BusTravelState>(
                      builder: (context, travelstate) {
                        if (travelstate is BusIsTravelingState) {
                          return Stack(
                            children: [
                              CancelRouteButton(
                                bus: widget.bus,
                              ),
                              sendLocationChangesBuilder()
                            ],
                          );
                        } else {
                          return InitRouteButton(
                            busId: widget.bus.id,
                          );
                        }
                      },
                    )
                  ],
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          )),
    );
  }

  sendLocationChangesBuilder() {
    LatLng? latlng;
    return BlocBuilder<UserLocationBloc, UserLocationState>(
      builder: (context, state) {
        if (state is UserLocationLoaded) {
          if (latlng != LatLng(state.latitude, state.longitude)) {
            Future.delayed(Duration.zero).then((value) =>
                Provider.of<SocketService>(context, listen: false)
                    .socket
                    .emit('change-location', [
                  [widget.bus.id, state.latitude, state.longitude]
                ]));
            latlng = LatLng(state.latitude, state.longitude);
          }
        }
        return Container();
      },
    );
  }
}

class InitRouteButton extends StatelessWidget {
  const InitRouteButton({
    Key? key,
    required this.busId,
  }) : super(key: key);

  final String busId;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 20,
        left: 0,
        child: GestureDetector(
          onTap: () async {
            bool cancel = await showAlert(
                context, '¿Seguro que desea empezar el viaje?', '');
            if (cancel) {
              Provider.of<BusTravelBloc>(context, listen: false)
                  .add(InitTravelEvent(
                busId,
                context,
              ));
            }
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.deepPurpleAccent.shade400,
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(20))),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            child: Row(
              children: [
                const Icon(Icons.navigation, color: Colors.white, size: 35),
                const SizedBox(
                  width: 20,
                ),
                Text('Iniciar trayecto'.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: MediaQuery.of(context).size.width * .02,
                    ))
              ],
            ),
          ),
        ));
  }
}

class CancelRouteButton extends StatelessWidget {
  const CancelRouteButton({
    Key? key,
    required this.bus,
  }) : super(key: key);
  final Bus bus;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 20,
        left: 0,
        child: GestureDetector(
          onTap: () async {
            bool cancel = await showAlert(
                context, '¿Seguro que desea terminar el viaje?', '');
            if (cancel) {
              Provider.of<BusTravelBloc>(context, listen: false)
                  .add(EndTravelEvent(bus.id, context));
              Provider.of<SocketService>(context, listen: false)
                  .socket
                  .emit('change-nextStop', [
                [bus.id, bus.firstStop]
              ]);
            }
          },
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(20))),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            child: Row(
              children: [
                const Icon(Icons.stop_circle_outlined,
                    color: Colors.white, size: 40),
                const SizedBox(
                  width: 20,
                ),
                Text('Terminar trayecto'.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                    ))
              ],
            ),
          ),
        ));
  }
}
