import 'package:flutter/material.dart';

class BusRoute extends StatelessWidget {
  final bool onn;
  final String directionName;
  final String checkIn;

  const BusRoute(
      {Key? key,
      required this.onn,
      required this.directionName,
      required this.checkIn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 60,
            child: Text(
                  this.checkIn,
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
          ),
          Row(
            children: [
              
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.location_on,
                color: onn ? Colors.blueAccent : Colors.grey,
                size: 35,
              ),
              SizedBox(
                width: 20,
              ),
              Text(this.directionName,
                  style: TextStyle(
                      fontFamily: 'Betm-Medium',
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: onn ? Colors.black87 : Colors.black54)),
            ],
          ),
          Spacer(),
          onn
              ? InkWell(
                  onTap: () {},
                  child: Icon(
                    Icons.notification_add,
                    color: Colors.black54,
                    size: 30,
                  ))
              : SizedBox()
        ],
      ),
    );
  }
}
