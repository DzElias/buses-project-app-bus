import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {

  final String stopName;
  final String distance;
  final String time;

  const CustomCard({Key? key, required this.stopName, required this.distance, required this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, 'bus-stop');
        },
        child: Container(
          width: 180,
          child: Container(
            margin:EdgeInsets.only(left: 10, top: 10) ,
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.blueAccent,
                      size: 28,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(this.stopName,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.black87)),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 35,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.directions_walk,
                          size: 18,
                          color: Colors.blueAccent,
                        ),
                        Text(
                          this.distance,
                          style: TextStyle(
                              color: Colors.black54, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          this.time,
                          style: TextStyle(
                              color: Colors.black54, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
