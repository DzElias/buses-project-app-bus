import 'package:bustracking/bloc/my_location/my_location_bloc.dart';
import 'package:bustracking/commons/models/bus.dart';
import 'package:bustracking/commons/widgets/map.dart';
import 'package:bustracking/pages/bus-page/models/bus_page_arguments.dart';
import 'package:bustracking/services/socket_service.dart';
import 'package:bustracking/pages/bus-page/widgets/bus-route.dart';
import 'package:bustracking/commons/widgets/custom-appbar.dart';
import 'package:bustracking/commons/widgets/panel_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:latlong2/latlong.dart';

const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoiZWxpYXNkaWF6MTAwNSIsImEiOiJja3d4eDQ3OTcwaHk3Mm51cjNmcWRvZjA2In0.AAF794oxyxFR_-wAvVwMfQ';
const MAPBOX_STYLE = 'mapbox/light-v10';

class BusPage extends StatefulWidget {
  @override
  State<BusPage> createState() => _BusPageState();
}

class _BusPageState extends State<BusPage> {
  static const double fabHeightClosed = 100.0;
  double fabHeight = fabHeightClosed;

  final panelController = PanelController();
  final mapController = MapController();

  List<LatLng> puntos = [];

  String busID = '';

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.connect();
    socketService.socket.on('change-locationReturn', handleBusLocation);
    super.initState();
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('change-locationReturn');
    socketService.socket.disconnect();

    super.dispose();
  }

  handleBusLocation(dynamic payload) {
    print(
        '<<<<<<<<<<-------Payload de change-LocationReturn--------->>>>>>>>>>>>>');
    print(payload);
    String payloadId = payload[0];
    if (payloadId == busID) {
      puntos.clear();
      puntos.add(LatLng(
        double.parse(payload[1]),
        double.parse(payload[2]),
      ));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var markers = puntos.map((latlng) {
      return Marker(
          height: 60,
          width: 60,
          point: latlng,
          builder: (_) => Stack(
                children: const [
                  Center(
                      child: Image(
                    image: AssetImage('assets/bus_point.png'),
                    height: 60,
                    width: 60,
                  )),
                ],
              ));
    }).toList();

    final args = ModalRoute.of(context)!.settings.arguments as BusPageArguments;

    final bus = args.bus;
    final String busStopName = args.busStopName;
    final LatLng busStopLatLng = args.busStopLatLng;

    final busLatLng = LatLng(bus.latitud, bus.longitud);
    
    busID = args.bus.id;

    // final String ruta = '${args.primeraParada} hasta ${args.ultimaParada}';
    final panelHeightClosed = MediaQuery.of(context).size.height * 0.1;
    final panelHeightOpen = MediaQuery.of(context).size.height * 0.53;

    return Scaffold(
        appBar: CustomAppBar(
          centerTitle: false,
          title: appbarTitle(bus.titulo, busLatLng, busStopLatLng, bus.linea),
        ),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            MapWidget(
              markers: markers,
              busStopLatLng: busStopLatLng,

              busRoute: bus.ruta
            ),
            slidingUpPanel(panelHeightOpen, panelHeightClosed, busStopName, bus),
            Positioned(
                right: 20, bottom: fabHeight, child: waitButton(busStopLatLng))
          ],
        ));
  }

  calculateDistance(LatLng point, LatLng myLocation) {
    //TODO: si es menor a mil pasar metros y si es mas pasar a km y redondear
    var _distanceInMeters = Geolocator.distanceBetween(point.latitude,
        point.longitude, myLocation.latitude, myLocation.longitude);

    int distance = _distanceInMeters.round();
    return distance;
  }

  calculateTime(LatLng point, LatLng myLocation) {
    String time;
    int hours = 0;
    int distance = calculateDistance(point, myLocation);

    //pasar tiempo a segundos y si son menos de 60 mostrar segundos xD
    int minutes = (((distance / 1000) * 60) / 12).round();
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

  appbarTitle(String busName, LatLng busLatLng, LatLng busStopLatLng, String lineaBus) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Linea ${lineaBus} ${busName}',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontFamily: 'Betm-Medium',
                  fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text(
                  "(${calculateTime(busLatLng, busStopLatLng)})",
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
  }

  Widget slidingUpPanel(double panelHeightOpen, double panelHeightClosed,String busStopName,Bus bus) {
    

    List route = bus.paradas;
    bool onnOrOff = false;
    var paradas = route.map((parada) {
      if (parada == busStopName) {
        onnOrOff = true;
      }
      return BusRoute(onn: onnOrOff, directionName: parada, checkIn: '12:00');
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
                        // children: [

                        //   BusRoute(
                        //     onn: false,
                        //     directionName: 'Km 7 Monday',
                        //     checkIn: '12:20',
                        //   ),

                        // ],
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

  waitButton(LatLng busStopLatLng) {
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
            onPressed: () {},
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

    if (distance < 30) {
      return true;
    } else {
      return false;
    }
  }
}
