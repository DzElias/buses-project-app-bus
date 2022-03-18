import 'dart:convert';

import 'package:bustracking/bloc/buses/buses_bloc.dart';
import 'package:bustracking/commons/models/bus.dart';
import 'package:bustracking/commons/widgets/map.dart';
import 'package:bustracking/pages/bus-stop-page/models/bus-stop-page-args.dart';
import 'package:bustracking/pages/bus-stop-page/widgets/bus_stop_page_map.dart';

import 'package:bustracking/pages/bus-stop-page/widgets/bus_widget.dart';
import 'package:bustracking/commons/widgets/custom-appbar.dart';
import 'package:bustracking/services/socket_service.dart';
import 'package:bustracking/commons/widgets/panel_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:latlong2/latlong.dart';

class BusStopPage extends StatefulWidget {
  // final String busStopName;

  // const BusStopPage({Key? key, required this.busStopName}) : super(key: key);

  @override
  State<BusStopPage> createState() => _BusStopPageState();
}

class _BusStopPageState extends State<BusStopPage> {
  late MapController mapController;
  @override
  void initState() {
    mapController = MapController();

    generateBusList();
    super.initState();
  }

  final ScrollController controller = ScrollController();

  List<Bus> buses = [];

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as BusStopPageArguments;
    final String busStopName = args.busStopName;
    final String busStopAdress = args.busStopAdress;
    final String time = args.time;
    final LatLng busStopLatLng = args.busStopLatLng;

    return Scaffold(
      appBar:
          CustomAppBar(title: appbarTitle(busStopName, busStopAdress, time)),
      body: Stack(
        children: [
          MapWidget(
            busStopLatLng: busStopLatLng,
            markers: [],
            busRoute: '',
          ),
          Column(
            children: [
              Spacer(),
              buses.isNotEmpty
                  ? slidingUpPanel(busStopName, context, busStopLatLng)
                  : SizedBox(),
              SizedBox(height: 10)
            ],
          ),
        ],
      ),
    );
  }

  generateBusList() async {
    final busesBloc = Provider.of<BusesBloc>(context, listen: false);
    List<Bus> busesToAdd = busesBloc.state.buses;
    setState(() {
      buses = busesToAdd;
    });
  }

  appbarTitle(String busStopName, String busStopAdress, String time) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              busStopName,
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.black87,
                  fontFamily: 'Betm-Medium',
                  fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text(
                  time,
                  style: TextStyle(
                      color: Colors.blue[600],
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.directions_walk,
                  size: 18,
                  color: Colors.blueAccent,
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              busStopAdress,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black45,
                  fontFamily: 'Betm-Medium',
                  fontWeight: FontWeight.bold),
            ),
          ],
        )
      ],
    );
  }

  slidingUpPanel(
      String busStopName, BuildContext context, LatLng busStopLatLng) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(children: [
        Container(
          child: Center(
            child: Text(
              'Buses llegando',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.white),
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.green,
          ),
          padding: EdgeInsets.symmetric(vertical: 6),
          margin: EdgeInsets.symmetric(horizontal: 3),
        ),
        Card(
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.all(10),
                height: 200,
                child: ListView.builder(
                  controller: controller,
                  itemCount: buses.length,
                  itemBuilder: (context, index) {
                    final item = buses[index];
                    print(buses);
                    return (item.proximaParada == busStopName)
                        ? BusWidget(
                            bus: item,
                            busStopName: busStopName,
                            busStopLatLng: busStopLatLng,
                            time: calculateTime(
                                LatLng(item.latitud, item.longitud),
                                busStopLatLng),
                          )
                        : SizedBox();
                  },
                )))
      ]),
    );
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

  // busesApproachingContainer() {
  //   return Column(
  //     children: [
  //       Container(
  //           alignment: Alignment.center,
  //           width: double.infinity,
  //           padding: EdgeInsets.symmetric(vertical: 20),
  //           decoration: BoxDecoration(
  //               color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
  //           child: Text('Buses acercándose',
  //               style: TextStyle(
  //                 fontSize: 20,
  //               ))),

  //       buses.isNotEmpty
  //           ? Center(
  //               child: Text('Hay buses'),
  //             )
  //           : Center(
  //               child: Text('No hay buses acercandose'),
  //             )

  // Column(
  //   children: [
  //     BusWidget(
  //       busName: 'Linea 270 Mburucuya Poty',
  //       busRoutes: 'Km 7 Monday hasta Barrio 23 de Octubre',
  //       time: '05 min',
  //     ),
  //     BusWidget(
  //       busName: 'Linea 270 Mburucuya Poty',
  //       busRoutes: 'Km 7 Monday hasta Barrio 23 de Octubre',
  //       time: '05 min',
  //     ),
  //     BusWidget(
  //       busName: 'Linea 270 Mburucuya Poty',
  //       busRoutes: 'Km 7 Monday hasta Barrio 23 de Octubre',
  //       time: '05 min',
  //     ),
  //     BusWidget(
  //       busName: 'Linea 270 Mburucuya Poty',
  //       busRoutes: 'Km 7 Monday hasta Barrio 23 de Octubre',
  //       time: '05 min',
  //     ),
  //   ],
  // ),
  //   ],
  // );
  // }
}
