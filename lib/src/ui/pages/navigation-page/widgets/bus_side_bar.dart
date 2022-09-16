import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:me_voy_chofer/src/domain/blocs/bus/bus_bloc.dart';
import 'package:me_voy_chofer/src/domain/blocs/bus_travel/bus_travel_bloc.dart';
import 'package:me_voy_chofer/src/domain/blocs/stop/stop_bloc.dart';
import 'package:me_voy_chofer/src/domain/entities/bus.dart';
import 'package:me_voy_chofer/src/domain/entities/stop.dart';
import 'package:me_voy_chofer/src/utils/matrix.dart';
import 'package:provider/provider.dart';

class BusSideBar extends StatefulWidget {
  const BusSideBar({
    Key? key,
    required this.bus,
  }) : super(key: key);

  final Bus bus;

  @override
  State<BusSideBar> createState() => _BusSideBarState();
}

class _BusSideBarState extends State<BusSideBar> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Positioned(
        right: 0,
        child: BlocBuilder<BusTravelBloc, BusTravelState>(
          builder: (context, travelState) {
            Color color = Colors.grey;
                if(travelState is BusIsTravelingState){
                  color = Colors.deepPurpleAccent.shade400;
                }
            return Container(
              padding:
                  EdgeInsets.only(top: height*0.065, left: 0, right: 0, bottom: 0),
              height: height,
              width: MediaQuery.of(context).size.width * .32,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 5.0,
                      offset: const Offset(0, 3),
                      blurStyle: BlurStyle.outer,
                      color: Colors.deepPurpleAccent.shade400),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent.shade400,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:  [
                        const Text('Ruta ',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                        Text(getRouteDistance(widget.bus),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  BlocBuilder<StopBloc, StopState>(
                    builder: (context, stopstate) {
                      var stopState = stopstate as StopsLoadedState;
                      return BlocBuilder<BusBloc, BusState>(
                        builder: (context, busestate) {
                          var busState = busestate as BusesLoadedState;
                          Bus bus = busState.buses.firstWhere((element) => element.id == widget.bus.id);
                          List<Stop> stops = getBusStops(bus, stopState.stops);
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: getStopColumn(stops, bus.nextStop, bus, context,(travelState is BusIsTravelingState )),
                          ));
                        },
                      );
                    },
                  ),
                  const Spacer(),
                  BusRouteStatePanel(busId: widget.bus.id, color: color)
                ],
              ),
            );
          },
        ));
  }

  List<Stop> getBusStops(Bus bus, List<Stop> allStops) {
    List<Stop> stops = [];
    for (var stop in bus.stops) {
      for (var singleStop in allStops) {
        if (stop == singleStop.id) {
          stops.add(singleStop);
        }
      }
    }
    return stops;
  }
  
  
  List<Widget> getStopColumn(List<Stop> stops, String nextStop, Bus bus, BuildContext context, bool isActive  ) {
    bool onnOrOff = false;
    
    List<Widget> stopsWidgets = stops.map((stop) {
      List<int> time = Matrix().calculateTimeBus(bus, stop.id, context, true );
      
      if(stop.id == nextStop){
        onnOrOff = true;
      }
    double height = MediaQuery.of(context).size.height;
      
      return Container(
        padding: EdgeInsets.only(top: height*0.02),
        child: Row(
          children: [
            // Container(
            //   width: 100,
            //   child: Text((time[0] != -1)? time[1] != 0? "${getTime(time[0], time[1], context )}": TimeOfDay.now().add(minute: 1).format(context) : "Ya paso",
            //       style: TextStyle(
            //           color: Colors.black54,
            //           fontSize: 20,
            //           fontWeight: FontWeight.bold)),
            // ),
            // const SizedBox(
            //   width: 15,
            // ),
            Icon(
              Icons.circle,
              color: (onnOrOff&&isActive) ? Colors.deepPurpleAccent : Colors.grey,
              size: height*0.03,
            ),
            SizedBox(
              width: height*0.02,
            ),
            Text(stop.title,
                style: TextStyle(
                    color: (onnOrOff&&isActive) ? Colors.black87 : Colors.black54,
                    fontSize: height*0.04,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }).toList();

    return stopsWidgets;
  }
  
  String getRouteDistance(Bus bus) {
    var stopsState = Provider.of<StopBloc>(context, listen: false).state;
    List<Stop> allStops = (stopsState as StopsLoadedState).stops;
    List<Stop> stops = [];
    for(var stopId in bus.stops){
      for(var singleStop in allStops){
        if(stopId == singleStop.id){
          stops.add(singleStop);
        }
      }
    } 
    int distanceInMeters = 0;
    for(int i =0; i<(stops.length - 1); i++){
      var singleStop = stops[i];
      var otherStop = stops[i + 1];
      LatLng stopLocation = LatLng(singleStop.latitude, singleStop.longitude);
      LatLng otherStopLocation = LatLng(otherStop.latitude, otherStop.longitude);
      distanceInMeters = distanceInMeters + Matrix().calculateDistanceInMeters(stopLocation, otherStopLocation);
    }

    int distanceInKilometers = (distanceInMeters/1000).round();
    return '${distanceInKilometers.toString()} Km';
  }
}

class BusRouteStatePanel extends StatelessWidget {
  const BusRouteStatePanel({
    Key? key,
    required this.busId,
    required this.color,
  }) : super(key: key);

  final String busId;
  final Color color;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return BlocBuilder<BusBloc, BusState>(
      builder: (context, bustate) {
        return BlocBuilder<StopBloc, StopState>(
          builder: (context, stopstate) {
            Bus bus = (bustate as BusesLoadedState)
                .buses
                .firstWhere((e) => e.id == busId);
            Stop nextStop = (stopstate as StopsLoadedState)
                .stops
                .firstWhere((e) => e.id == bus.nextStop);

            return Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: height*0.03,),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(Icons.directions_bus, color: Colors.white, size: height*0.05),
                    const SizedBox(
                      width: 10,
                    ),
                    Text('Linea ${bus.line} - ${bus.company}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: height*0.030,
                            fontWeight: FontWeight.w500))
                  ]),
                  SizedBox(
                    height: height*0.04,
                  ),
                  Row(
                    children: [
                      Icon(Icons.arrow_forward_ios, color: Colors.white, size: height*0.05),
                      const SizedBox(
                        width: 10,
                      ),
                      Text('Sgte Parada | ${nextStop.title}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: height*0.030,
                              fontWeight: FontWeight.w500))
                    ],
                  ),
                  SizedBox(
                    height: height*0.04,
                  ),
                  Row(
                    children: [
                      Icon(Icons.groups, color: Colors.white, size: height*0.05),
                      const SizedBox(
                        width: 10,
                      ),
                      Text('Esperando | ${nextStop.waiting.toString()}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: height*0.030,
                              fontWeight: FontWeight.w500))
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

}
  getTime(int hours, int min, BuildContext context){
  
    TimeOfDay time = TimeOfDay.now().add(hour: hours, minute: min);

    return time.format(context);
  }
  extension TimeOfDayExtension on TimeOfDay {
    TimeOfDay add({int hour = 0, int minute = 0}) {
      for(int i =0; ((this.minute + minute) >= 60); i++){
        hour++;
        minute = minute - (60 - this.minute);
      }
    
      if(this.hour + hour >= 24){
        hour = - (this.hour ) + ((this.hour + hour) - 24);
      }
    
    return replacing(hour: ((this.hour + hour) != 0) ?(this.hour + hour) : null , minute: ((this.minute + minute) > 0) ? this.minute + minute: null);
  }
}
