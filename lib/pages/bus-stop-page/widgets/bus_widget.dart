import 'package:bustracking/commons/models/bus.dart';
import 'package:bustracking/pages/bus-page/models/bus_page_arguments.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class BusWidget extends StatelessWidget {
  final Bus bus;
  final String time;
  final LatLng busStopLatLng;
  final String busStopName;

  const BusWidget(
      {Key? key,
      required this.busStopLatLng, required this.busStopName, required this.bus, required this.time})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, 'bus-page', arguments: BusPageArguments(bus: this.bus, busStopLatLng: this.busStopLatLng, busStopName: this.busStopName));
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
                    Text("Linea ${bus.linea} ${bus.titulo}",
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
