import 'package:bustracking/pages/bus-page/models/bus_page_arguments.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class BusWidget extends StatelessWidget {
  final String busName;
 
  final String time;
  final String busId;
   final LatLng busLocation;
  final String linea;
  final List<dynamic> paradas;
 final  String primeraParada;
  final String ultimaParada;
  final String proximaParada;
  final LatLng busStopLatLng;

  const BusWidget(
      {Key? key,
      required this.busName,
      
      required this.time, required this.busId, required this.busLocation, required this.linea, required this.paradas, required this.primeraParada, required this.ultimaParada, required this.proximaParada, required this.busStopLatLng})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, 'bus-page', arguments: BusPageArguments(busId, busLocation,busName, linea, paradas, primeraParada, ultimaParada, proximaParada, busStopLatLng));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.directions_bus,
                      color: Colors.green,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(busName,
                        style: TextStyle(
                            fontFamily: 'Betm-Medium',
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      time,
                      style: TextStyle(color: Colors.black54),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.keyboard_arrow_right, color: Colors.black87)
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
