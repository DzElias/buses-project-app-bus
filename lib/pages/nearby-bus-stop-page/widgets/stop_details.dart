import 'package:bustracking/commons/models/stop.dart';
import 'package:bustracking/pages/nearby-bus-stop-page/widgets/custom-card.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class StopDetails extends StatelessWidget {
  final Stop busStop;
  final bool isNearest;
  final int distanceInMeters;
  final String time;

  const StopDetails({
    Key? key,
    required this.distanceInMeters,
    required this.busStop,
    required this.time,
    this.isNearest = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: CustomCard(
          stopId: busStop.id,
          stopLatLng: LatLng(busStop.latitud, busStop.longitud),
          isNearest: isNearest,
          stopName: busStop.titulo,
          distance: (distanceInMeters > 1000)
              ? '${(distanceInMeters / 1000).round()} Km '
              : '${distanceInMeters} m ',
          time: '(${time})',
        ));
  }
}
