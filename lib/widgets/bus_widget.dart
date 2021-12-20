import 'package:flutter/material.dart';

class BusWidget extends StatelessWidget {
  final String busName;
  final String busRoutes;
  final String time;

  const BusWidget({Key? key, required this.busName, required this.busRoutes, required this.time}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, 'bus-page');
      },
      child: Container(
        margin: EdgeInsets.all(20),
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
            Row(
              children: [
                SizedBox(
                  width: 40,
                ),
                Text(
                  busRoutes,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black54),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
