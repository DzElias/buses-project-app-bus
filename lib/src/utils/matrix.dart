//A class for diferent map utils ( distance, time, etc.)

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:me_voy_chofer/src/domain/blocs/stop/stop_bloc.dart';
import 'package:me_voy_chofer/src/domain/entities/bus.dart';
import 'package:me_voy_chofer/src/domain/entities/stop.dart';
import 'package:provider/provider.dart';

class Matrix {
   String calculateDistanceString(LatLng pointA, LatLng pointB){
    double distanceInMeters = Geolocator.distanceBetween(
      pointA.latitude,
      pointA.longitude,
      pointB.latitude,
      pointB.longitude
    );

    int distance = distanceInMeters.round();

    if(distance > 1000){
      
      distance = (distance / 1000).round();
      return '$distance Km';
    }else if (distance <= 0){
      return '10 m';
    }else{
      return '$distance m';
    }
  }

  int calculateDistanceInMeters(LatLng pointA, LatLng pointB){
     double distanceInMeters = Geolocator.distanceBetween(
      pointA.latitude,
      pointA.longitude,
      pointB.latitude,
      pointB.longitude
    );

    int distance = distanceInMeters.round();
    return distance;
  }


   calculateTime( String stopID, LatLng userLocation, BuildContext context, bool returnListInt ){
    var stopState = Provider.of<StopBloc>(context, listen: false).state;
    
    if(stopState is StopsLoadedState){
      Stop stop = stopState.stops[stopState.stops.indexWhere((element) => element.id == stopID)];
     
        //Calcular distancia de parada a la ubicacion del usuario
        
        String time;
        int hours = 0;
        double distanceInMeters = Geolocator.distanceBetween(stop.latitude, stop.longitude, userLocation.latitude, userLocation.longitude);
        int minutes = (((distanceInMeters / 1000) * 60) / 4).round();

        while (minutes > 60) {
          hours = hours + 1;
          minutes = minutes - 60;
        }
        if(returnListInt){
          return [hours, minutes];
        }
        if(minutes == 0){
          return '30 seg';
        }
        if (hours == 0) {
          time = '$minutes min';
          return time;
        } else {
          time = "$hours h $minutes min";
          return time;
        }
        
    }
    
    return '5 min';
  }
  calculateTimeBus(Bus bus, String stopId, BuildContext context, returnListInt){

    int nextStopIndex = bus.stops.indexWhere((element) => element == bus.nextStop);
    int stopIndex = bus.stops.indexWhere((element) => element == stopId);
  

    int distance = 0;

    for(int i = nextStopIndex; i != stopIndex;)
    {
      

      var stopA = stopById(bus.stops[i], context);
      var stopB;


      if((i + 1) > bus.stops.indexWhere((element) => element == bus.stops.last))
      {
        stopB = stopById(bus.stops[0], context);
      }
      if((i+1) <= bus.stops.indexWhere((element) => element == bus.stops.last)){
        stopB = stopById(bus.stops[i + 1], context);
      }

      LatLng stopALatLng = LatLng(stopA.latitude, stopA.longitude);
      LatLng stopBLatLng = LatLng(stopB.latitude, stopB.longitude);

      distance = distance + calculateDistanceInMeters(stopALatLng, stopBLatLng);

      if(i == bus.stops.indexWhere((element) => element == bus.stops.last))
      {
        i = 0; 
      }else
      {
        i++;
      }
    
    }
    int hours = 0;
    int minutes = (((distance / 1000) * 60) / 12).round();
    if(returnListInt){
      while (minutes > 60) {
        hours = hours + 1;
        minutes = minutes - 60;
      }
      return [hours, minutes];
    }
    return minutes;
  }

  String calculateTimeBusString(Bus bus, String stopId, BuildContext context){

    int nextStopIndex = bus.stops.indexWhere((element) => element == bus.nextStop);
    int stopIndex = bus.stops.indexWhere((element) => element == stopId);
  

    int distance = 0;

    for(int i = nextStopIndex; i != stopIndex;)
    {
      

      var stopA = stopById(bus.stops[i], context);
      var stopB;


      if((i + 1) > bus.stops.indexWhere((element) => element == bus.stops.last))
      {
        stopB = stopById(bus.stops[0], context);
      }
      if((i+1) <= bus.stops.indexWhere((element) => element == bus.stops.last)){
        stopB = stopById(bus.stops[i + 1], context);
      }

      LatLng stopALatLng = LatLng(stopA.latitude, stopA.longitude);
      LatLng stopBLatLng = LatLng(stopB.latitude, stopB.longitude);

      distance = distance + calculateDistanceInMeters(stopALatLng, stopBLatLng);

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

  Stop stopById(String stopId, BuildContext context ){
    final stopsBloc = Provider.of<StopBloc>(context, listen: false);

    var stopsBlocState = stopsBloc.state;
    if(stopsBlocState is StopsLoadedState){
      Stop stop = stopsBlocState.stops.firstWhere((element) => element.id == stopId);
      return  stop;
    }

    throw Exception();
  }
}