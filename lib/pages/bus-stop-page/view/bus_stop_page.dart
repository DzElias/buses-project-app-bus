// ignore_for_file: unnecessary_import

import 'package:bustracking/bloc/buses/buses_bloc.dart';
import 'package:bustracking/bloc/stops/stops_bloc.dart';
import 'package:bustracking/commons/models/bus.dart';
import 'package:bustracking/commons/models/stop.dart';
import 'package:bustracking/commons/widgets/map.dart';
import 'package:bustracking/pages/bus-stop-page/models/bus-stop-page-args.dart';

import 'package:bustracking/pages/bus-stop-page/widgets/bus_widget.dart';
import 'package:bustracking/commons/widgets/custom-appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

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

    super.initState();
  }

  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as BusStopPageArguments;
    final String busStopName = args.busStopName;
    final String time = args.time;
    final LatLng busStopLatLng = args.busStopLatLng;
    final String stopId = args.stopId;
    generateBusList(busStopLatLng);
    return Scaffold(
      appBar: CustomAppBar(
        title: appbarTitle(busStopName, time),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          MapWidget(
            busStopLatLng: busStopLatLng,
            destino2: LatLng(0, 0),
            markers: [],
            busRoute: '',
            selectedStops: [stopId],
            viajando: false,
          ),
          Column(
            children: [
              Spacer(),
              slidingUpPanel(stopId, context, busStopLatLng),
              SizedBox(height: 10)
            ],
          ),
        ],
      ),
    );
  }

  List generateBusList(LatLng stopLatLng) {
    List buses = [];
    final busesBloc = Provider.of<BusesBloc>(context, listen: false);
    List<Bus> busesToAdd = busesBloc.state.buses;

    for (var singleBus in busesToAdd) {
      buses.add(singleBus);
    }
    
      buses.sort((a, b) {
        Stop aProx = stopById(a.proximaParada);
        Stop bProx = stopById(b.proximaParada);
        LatLng aLatLng = LatLng(aProx.latitud, aProx.longitud);
        LatLng bLatLng = LatLng(bProx.latitud, bProx.longitud);

        return calculateDistance(aLatLng, stopLatLng).compareTo(calculateDistance(bLatLng, stopLatLng));
      });
    return buses;

  
  }

  appbarTitle(String busStopName, String time) {
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
      ],
    );
  }

  slidingUpPanel(String stopId, BuildContext context, LatLng busStopLatLng) {
    return BlocBuilder<BusesBloc, BusesState>(
      builder: (context, state) {
        List buses = generateBusList(busStopLatLng);
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(children: [
            Container(
              child: Center(
                child: Text(
                  'Proximos Buses',
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
              padding: EdgeInsets.symmetric(vertical: 8),
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
                        bool isComing = false;
                        int prox = item.paradas.indexWhere((element) => element == item.proximaParada);
                        int stopI = item.paradas.indexWhere((element) => element == stopId);

                        if ((stopI >= 0) && (stopI >= prox)) {
                          isComing = true;
                        }

                        return isComing
                            ? BusWidget(
                                bus: item,
                                stop: stopById(stopId),
                                time: calculateTime(
                                    LatLng(item.latitud, item.longitud),
                                    busStopLatLng),
                              )
                            : SizedBox();
                      },
                    )))
          ]),
        );
      },
    );
  }

  Stop stopById(stopID) {
    final stops = Provider.of<StopsBloc>(context, listen: false).state.stops;

    int index = stops.indexWhere((element) => stopID == element.id);
    var stop = stops[index];
    return stop;
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
    if (hours == 0 && minutes > 0) {
      time = '$minutes min';
      return time;
    } else if (minutes == 0) {
      time = "Llegando";
      return time;
    } else {
      time = "$hours h $minutes min";
      return time;
    }
  }
}
