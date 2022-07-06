import 'package:user_app/bloc/travel/travel_bloc.dart';
import 'package:user_app/bloc/buses/buses_bloc.dart';
import 'package:user_app/bloc/map/map_bloc.dart';
import 'package:user_app/bloc/my_location/my_location_bloc.dart';
import 'package:user_app/bloc/stops/stops_bloc.dart';
import 'package:user_app/pages/bus-page/models/bus_page_arguments.dart';
import 'package:user_app/pages/bus-page/widgets/bus-route.dart';
import 'package:user_app/commons/models/bus.dart';
import 'package:user_app/commons/models/stop.dart';
import 'package:user_app/commons/widgets/map.dart';
import 'package:user_app/commons/widgets/custom-appbar.dart';
import 'package:user_app/commons/widgets/panel_widget.dart';
import 'package:user_app/services/notification_service.dart';
import 'package:user_app/services/socket_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:latlong2/latlong.dart';
import 'package:timezone/data/latest.dart' as tz;

const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoiZWxpYXNkaWF6MTAwNSIsImEiOiJja3d4eDQ3OTcwaHk3Mm51cjNmcWRvZjA2In0.AAF794oxyxFR_-wAvVwMfQ';
const MAPBOX_STYLE = 'mapbox/light-v10';

class BusPage extends StatefulWidget {
  @override
  State<BusPage> createState() => _BusPageState();
}

class _BusPageState extends State<BusPage> with TickerProviderStateMixin {
  static const double fabHeightClosed = 100.0;
  double fabHeight = fabHeightClosed;

  final panelController = PanelController();

  List<LatLng> puntos = [];

  String busID = '';

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as BusPageArguments;

    final LatLng busStopLatLng = LatLng(args.stop.latitude, args.stop.longitude);
    final String stopId = args.stop.id;
    final List<String> stopsSelected = args.stopsSelected;
    final destino = args.destino;
    busID = args.bus.id;

    // final String ruta = '${args.primeraParada} hasta ${args.ultimaParada}';
    final panelHeightClosed = MediaQuery.of(context).size.height * 0.1;
    final panelHeightOpen = MediaQuery.of(context).size.height * 0.53;

    return BlocBuilder<TravelBloc, TravelState>(
      builder: (context, trstate) {
        TravelState trs = trstate;

        return WillPopScope(
          onWillPop: (trstate.waiting || trstate.waiting || trs.isHere) ? _onWillPop :() async{return true;} ,
          child: Scaffold(
              appBar: CustomAppBar(
                backgroundColor: Colors.white,
                centerTitle: false,
                title: appbarTitle(stopById(stopId), busID),
                goBack: (trstate.waiting || trstate.waiting || trs.isHere) ? false : true),
              body: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      BlocBuilder<BusesBloc, BusesState>(
                        builder: (context, state) {
                          var bus = state.buses[state.buses.indexWhere((element) => element.id == busID)];
                          LatLng busLatLng = LatLng(bus.latitude, bus.longitude);

                          return MapWidget(
                              selectedStops: stopsSelected,
                              destino2: destino,
                              viajando: trs.traveling,
                              markers: [
                                Marker(
                                    height: 60,
                                    width: 60,
                                    point: busLatLng,
                                    builder: (_) => Stack(
                                          children: const [
                                            Center(
                                                child: Image(
                                              image: AssetImage(
                                                  'assets/bus_point.png'),
                                              height: 60,
                                              width: 60,
                                            )),
                                          ],
                                        ))
                              ],
                              busStopLatLng: busStopLatLng,
                              busRoute: bus.ruta);
                        },
                      ),
                      BlocBuilder<BusesBloc, BusesState>(
                        builder: (context, state) {
                          Bus bus = state.buses[state.buses
                              .indexWhere((element) => element.id == busID)];
                          return slidingUpPanel(
                              panelHeightOpen, panelHeightClosed, stopId, bus);
                        },
                      ),
                      (trs.waiting || trs.isHere)
                          ? Positioned(
                              top: 0,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Center(
                                    child: !trs.isHere
                                        ? Text("Espera al bus en la parada",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18))
                                        : Text(
                                            "El bus esta llegando, identificalo y subite!",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          )),
                                decoration: BoxDecoration(color: Colors.green),
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                              ))
                          : SizedBox(),
                      (!trs.waiting && !trs.isHere && !trs.traveling)
                          ? Positioned(
                              right: 20,
                              bottom: fabHeight,
                              child: waitButton(busStopLatLng, stopId, args.bus,
                                  args.stop, destino))
                          : (!trs.traveling && trs.isHere)
                              ? Positioned(
                                  bottom: fabHeight,
                                  right: 20,
                                  child: Container(
                                    child: confirmSubBtn(
                                        args.bus, destino, args.stop),
                                  ))
                              : SizedBox(),
                      trs.waiting? waitingBuilder(busStopLatLng, stopId, trs)
                          : SizedBox(),
                      trs.traveling
                          ? viajandoBuilder(destino, context)
                          : Container()
                    ],
                  )
                ),
        );
      },
    );
  }

  var sw = false;

  BlocBuilder<BusesBloc, BusesState> waitingBuilder(
      LatLng busStopLatLng, String stopId, TravelState trs) {
    return BlocBuilder<BusesBloc, BusesState>(
      builder: (context, state) {
        var bus = state
            .buses[state.buses.indexWhere((element) => element.id == busID)];
        LatLng busLatLng = LatLng(bus.latitude, bus.longitude);

        if (calculateDistance(busLatLng, busStopLatLng) < 200) {
          NotificationService().showNotification(1, "Tu bus esta llegando!!",
              "Acercate a la parada e identifica al bus", 1);

          if (!sw) {
            Provider.of<SocketService>(context, listen: false).socket.emit("substractWait", stopId);
            sw = true;
          }

          Provider.of<TravelBloc>(context, listen: false).add(OnIsHereEvent(true));
          Provider.of<TravelBloc>(context, listen: false).add(OnDesWaitingEvent());
        }
        return Positioned(
          bottom: fabHeight,
          right: 20,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary:  Colors.redAccent,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              onPressed: () {
                Provider.of<TravelBloc>(context, listen: false).add(OnDesWaitingEvent());
                Provider.of<SocketService>(context, listen: false).socket.emit("substractWait", stopId);

                },
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.hourglass_empty),
                    Text(
                      'Cancelar espera',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }

  ElevatedButton confirmSubBtn(Bus bus, LatLng destino, Stop stop) {
    return ElevatedButton(
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.directions_walk),
            Text(
              'Confirmar Subida',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      onPressed: () {
        Provider.of<TravelBloc>(context, listen: false)
            .add(OnIsHereEvent(false));
        Provider.of<TravelBloc>(context, listen: false)
            .add(OnDesWaitingEvent());
        Provider.of<TravelBloc>(context, listen: false)
            .add(OnTravelingEvent(bus: bus, destino: destino, stop: stop));
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.red,
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(20.0),
        ),
      ),
    );
  }

  BlocBuilder<BusesBloc, BusesState> viajandoBuilder(
      LatLng destino, BuildContext context) {
    final busesBloc = Provider.of<BusesBloc>(context, listen: false);
    var bus = busesBloc.state.buses[
        busesBloc.state.buses.indexWhere((element) => element.id == busID)];
    LatLng busLatLng = LatLng(bus.latitude, bus.longitude);

    final mapBloc = Provider.of<MapBloc>(context, listen: false);
    animatedMapMove(busLatLng, 16, mapBloc.mapController2);

    return BlocBuilder<BusesBloc, BusesState>(
      builder: (context, state) {
        var bus = state
            .buses[state.buses.indexWhere((element) => element.id == busID)];
        LatLng busLatLng = LatLng(bus.latitude, bus.longitude);

        final mapBloc = Provider.of<MapBloc>(context, listen: false);
        MapController mapController = mapBloc.mapController2;
        animatedMapMove(busLatLng, 16, mapController);

        if (destino.latitude != 0) {
          if (calculateDistance(busLatLng, destino) < 50) {
            NotificationService().showNotification(
                1,
                "Has llegado a tu destino!!",
                "Ten cuidado al bajar, Hasta luego!",
                1);

            Provider.of<TravelBloc>(context, listen: false)
                .add(OnDesTravelingEvent());
          }
        }
        final myLocationBloc =Provider.of<MyLocationBloc>(context, listen: false);
        if(calculateDistance(busLatLng, myLocationBloc.state.location! ) > 50){
          Provider.of<TravelBloc>(context, listen: false).add(OnDesTravelingEvent());
          animatedMapMove(myLocationBloc.state.location!, 16, mapController);
        }

        if (destino.latitude == 0) {
          return Positioned(
              child: Positioned(
                  bottom: fabHeight,
                  right: 20,
                  child: Container(
                    child: ElevatedButton(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.directions_walk),
                            Text(
                              'Confirmar Bajada',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () {
                        final myLocationBloc =
                            Provider.of<MyLocationBloc>(context, listen: false);
                        animatedMapMove(
                            myLocationBloc.state.location!, 16, mapController);

                        Provider.of<TravelBloc>(context, listen: false)
                            .add(OnDesTravelingEvent());
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  )));
        }

        return Container();
      },
    );
  }

  int calculateDistance(LatLng point, LatLng myLocation) {
    //TODO: si es menor a mil pasar metros y si es mas pasar a km y redondear
    var _distanceInMeters = Geolocator.distanceBetween(point.latitude,
        point.longitude, myLocation.latitude, myLocation.longitude);

    int distance = _distanceInMeters.round();
    return distance;
  }

  
  calculateTime(Bus bus, String stopId, bool retrn){
    int nextStopIndex = bus.stops.indexWhere((element) => element == bus.nextStop);
    int stopIndex = bus.stops.indexWhere((element) => element == stopId);
  

    int distance = 0;

    for(int i = nextStopIndex; i != stopIndex;)
    {
      

      var stopA = stopById(bus.stops[i]);
      var stopB;


      if((i + 1) > bus.stops.indexWhere((element) => element == bus.stops.last))
      {
        stopB = stopById(bus.stops[0]);
      }
      if((i+1) <= bus.stops.indexWhere((element) => element == bus.stops.last)){
        stopB = stopById(bus.stops[i + 1]);
      }

      LatLng stopALatLng = LatLng(stopA.latitude, stopA.longitude);
      LatLng stopBLatLng = LatLng(stopB.latitud, stopB.longitud);

      distance = distance + calculateDistance(stopALatLng, stopBLatLng);

      if(i == bus.stops.indexWhere((element) => element == bus.stops.last))
      {
        i = 0; 
      }else
      {
        i++;
      }
    
    }
    List<int> time = [];
    int hours = 0;
    int minutes = (((distance / 1000) * 60) / 12).round();
    while (minutes > 60) {
      hours = hours + 1;
      minutes = minutes - 60;
    }

    time.add(hours);
    time.add(minutes);

    if(retrn){
      return time;
    }

    String timeStr = "30 seg";

    if(time[0] == 0  && time[1] != 0){
      timeStr = "${time[1]} min";
    }else if (time[0] != 0  && time[1] != 0){
      timeStr = "${time[0]} h ${time[1]} min";
    }else if(time[0] != 0  && time[1] == 0){
      timeStr = "${time[0]} h";
    }
     return timeStr;

  
}

 

  appbarTitle(Stop stop, String busId) {

    return BlocBuilder<BusesBloc, BusesState>(
      builder: (context, state) {
        Bus bus = state.buses[state.buses.indexWhere((element) => element.id == busId)];
        String time = calculateTime(bus, stop.id, false);
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Linea ${bus.line} - ${bus.company}',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontFamily: 'Betm-Medium',
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text(
                      "($time)",
                      style: TextStyle(color: Colors.blue, fontSize: 13),
                    ),
                    Icon(
                      Icons.directions_bus,
                      size: 18,
                      color: Colors.blueAccent,
                    ),
                  ],
                )
              ],
            ),
          ],
        );
      },
    );
  }

  Widget slidingUpPanel(double panelHeightOpen, double panelHeightClosed, String stopId, Bus bus) {
    List route = bus.stops;
    bool onnOrOff = false;
    var paradas = route.map((stopID) {

      if (stopID == bus.nextStop) {
        onnOrOff = true;
      }
      Stop stop = stopById(stopID);

      List<int> time = calculateTime(bus, stop.id, true);
      return BusRoute(
          onn: onnOrOff,
          directionName: stop.title,
          time: onnOrOff ? time : [-1]);
    }).toList();
    return SlidingUpPanel(
        controller: panelController,
        maxHeight: panelHeightOpen,
        minHeight: panelHeightClosed,
        parallaxEnabled: true,
        parallaxOffset: .5,
        panelBuilder: (controller) => PanelWidget(
              panelController: panelController,
              controller: controller,
              panelContent: Column(
                children: [
                  Column(
                    children: [
                      Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Text('Ruta del Bus',
                              style: TextStyle(
                                fontSize: 20,
                              ))),
                      Column(
                        children: paradas,
                      ),
                    ],
                  ),
                ],
              ),
            ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        onPanelSlide: (position) => setState(() {
              final panelMaxScrollExtent = panelHeightOpen - panelHeightClosed;

              fabHeight = position * panelMaxScrollExtent + fabHeightClosed;
            }));
  }

  Stop stopById(stopID) {
    final stops = Provider.of<StopsBloc>(context, listen: false).state.stops;

    int index = stops.indexWhere((element) => stopID == element.id);
    var stop = stops[index];
    return stop;
  }

  waitButton(
      LatLng busStopLatLng, String stopID, Bus bus, Stop stop, LatLng destino) {
    return BlocBuilder<MyLocationBloc, MyLocationState>(
      builder: (context, state) {
        return ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: isNear(state.location, busStopLatLng)
                  ? Colors.blueAccent
                  : Colors.grey,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0),
              ),
            ),
            onPressed: () {
              if (isNear(state.location, busStopLatLng)) {
                var service =
                    Provider.of<SocketService>(context, listen: false);
                service.socket.emit("addWait", stopID);
                sw = false;
                Provider.of<TravelBloc>(context, listen: false)
                    .add(OnWaitingEvent(
                  bus: bus,
                  stop: stop,
                  destino: destino,
                ));
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.hourglass_empty),
                  Text(
                    'Esperar aqui',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }

  bool isNear(LatLng? userLocation, LatLng busStop) {
    int distance = calculateDistance(userLocation!, busStop);

    if (distance < 150) {
      return true;
    } else {
      return false;
    }
  }

  animatedMapMove(LatLng destLocation, double destZoom, MapController mapController) {
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
