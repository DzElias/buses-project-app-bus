import 'package:latlong2/latlong.dart';

class BusStop{
  String id;
  String title;
  String adress;
  LatLng location;
  String imageLink;
  BusStop({
    required this.id,
    required this.title, 
    required this.adress,
    required this.location,
    required this.imageLink
  });

  // factory BusStop.fromJson(Map<String, dynamic> json) {

  //   return BusStop(
  //     id: json['_id'],
  //     title: json['descripcion'],
  //     location: LatLng(json['latitud'] as double, json['longitud'] as double ));
    
  // }

}


