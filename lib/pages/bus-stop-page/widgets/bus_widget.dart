import 'package:bustracking/commons/models/bus.dart';
import 'package:bustracking/commons/models/stop.dart';
import 'package:bustracking/pages/bus-page/models/bus_page_arguments.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class BusWidget extends StatelessWidget {
  final Bus bus;
  final String time;
  final Stop stop;

  const BusWidget(
      {Key? key,
      
      required this.bus,
      required this.time, required this.stop})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, 'bus-page',
            arguments: BusPageArguments(
                destino: LatLng(0,0),
                bus: this.bus,
                stop: this.stop,
                stopsSelected: [stop.id],
                waiting: false
                ));
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
