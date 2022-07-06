// ignore_for_file: unnecessary_import

import 'package:user_app/bloc/buses/buses_bloc.dart';
import 'package:user_app/bloc/stops/stops_bloc.dart';
import 'package:user_app/commons/models/bus.dart';
import 'package:user_app/commons/models/stop.dart';
import 'package:user_app/commons/widgets/map.dart';
import 'package:user_app/pages/bus-stop-page/models/bus-stop-page-args.dart';

import 'package:user_app/pages/bus-stop-page/widgets/bus_widget.dart';
import 'package:user_app/commons/widgets/custom-appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import 'package:latlong2/latlong.dart';

class BusStopPage extends StatefulWidget {

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
    final args = ModalRoute.of(context)!.settings.arguments as BusStopPageArguments;
    final String busStopName = args.busStopName;
    final String time = args.time;
    final LatLng busStopLatLng = args.busStopLatLng;
    final String stopId = args.stopId;
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
              slidingUpPanel(stopId, context),
              SizedBox(height: 10)
            ],
          ),
        ],
      ),
    );
  }

  List generateBusList(String stopId) {
    List buses = [];
    final busesBloc = Provider.of<BusesBloc>(context, listen: false);
    List<Bus> busesToAdd = busesBloc.state.buses;

    for (var singleBus in busesToAdd) {
      if(singleBus.stops.indexWhere((element) => element == stopId) >= 0 ){
        buses.add(singleBus);
      }

    }
    
      buses.sort((a, b) {
        List<int> aTime = calculateTime(a, stopId, true);
        List<int> bTime = calculateTime(b, stopId, true);

        
        aTime[1] = aTime[1] + (60*aTime[0]);
        bTime[1] = bTime[1] + (60*bTime[0]);
       

        return (aTime[1]).compareTo((bTime[1]));
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

  slidingUpPanel(String stopId, BuildContext context) {
    return BlocBuilder<BusesBloc, BusesState>(
      builder: (context, state) {
        List buses = generateBusList(stopId);
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
                        int prox = item.stops.indexWhere((element) => element == item.nextStop);
                        int stopI = item.stops.indexWhere((element) => element == stopId);

                        if ((stopI >= 0) && (stopI >= prox)) {
                          isComing = true;
                        }

                        return isComing
                            ? BusWidget(
                                bus: item,
                                stop: stopById(stopId),
                                time: calculateTime(item, stopId, false),
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
      LatLng stopBLatLng = LatLng(stopB.latitude, stopB.longitude);

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


  int calculateDistance(LatLng point, LatLng myLocation) {
    //TODO: si es menor a mil pasar metros y si es mas pasar a km y redondear
    var _distanceInMeters = Geolocator.distanceBetween(point.latitude,
        point.longitude, myLocation.latitude, myLocation.longitude);

    int distance = _distanceInMeters.round();
    return distance;
  }

  
}
