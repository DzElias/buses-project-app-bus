import 'package:bustracking/pages/bus-stop-page/models/bus-stop-page-args.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class CustomCard extends StatelessWidget {
  final String stopName;
  final String distance;
  final String time;

  final bool isNearest;
  final LatLng stopLatLng;
  final String stopId;

  const CustomCard(
      {Key? key,
      required this.stopName,
      required this.distance,
      required this.time,
  
      required this.stopLatLng,
      required this.stopId,
      this.isNearest = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, 'bus-stop',
              arguments: BusStopPageArguments(this.stopName,this.time, this.stopLatLng, this.stopId));
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    // Container(
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    //     image: DecorationImage(
                    //       image: NetworkImage(imageLink),
                    //       fit: BoxFit.cover,
                    //     ),
                    //   ),
                    // ),
                    isNearest
                        ? Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(3)),
                                    padding: EdgeInsets.all(6),
                                    child: Text(
                                      'Parada mas cercana',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                    ))),
                          )
                        : SizedBox(),

                    // Padding(
                    //         padding: const EdgeInsets.all(6.0),
                    //         child: Align(
                    //             alignment: Alignment.topLeft,
                    //             child: Container(
                    //               decoration: BoxDecoration(
                    //                 color: Colors.redAccent,
                    //                 borderRadius: BorderRadius.circular(3)
                    //               ),
                    //                 padding: EdgeInsets.all(6),

                    //                 child: Text(
                    //                   'Prox Bus a 6 min',
                    //                   style:
                    //                       TextStyle(color: Colors.white,fontSize: 13, fontWeight: FontWeight.w500),
                    //                 ))),
                    //       )
                  ],
                ),
              ),
              const SizedBox(
                height: 2,
              ),

              //  Image.network('https://lh5.googleusercontent.com/p/AF1QipP2HKxlEXvye4O32N0K1-DbZE6zsJ4Dy9mWnZrY=w408-h498-k-no')),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Image(
                        image: AssetImage('assets/busStop.png'),
                        width: 40,
                        height: 40,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(this.stopName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colors.black87)),
                          Row(
                            children: [
                              const Icon(
                                Icons.directions_walk,
                                size: 18,
                                color: Colors.blueAccent,
                              ),
                              Text(
                                this.distance,
                                style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                this.time,
                                style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '¡Ir allá!',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueAccent),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.blueAccent,
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
