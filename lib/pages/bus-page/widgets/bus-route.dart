import 'package:flutter/material.dart';

class BusRoute extends StatelessWidget {
  final bool onn;
  final String directionName;
  List<int> time  =  [];

 BusRoute(
      {Key? key,
      required this.onn,
      required this.directionName,
      required this.time})
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
            child: Text((time[0] != -1)? time[1] != 0? "${getTime(time[0], time[1], context )}": "Llegando" : "Ya paso",
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
                      fontSize: 16,
                      color: onn ? Colors.black87 : Colors.black54)),
            ],
          ),
          Spacer(),
          // onn
          //     ? InkWell(
          //         onTap: () {},
          //         child: Icon(
          //           Icons.notification_add,
          //           color: Colors.black54,
          //           size: 30,
          //         ))
          //     : SizedBox()
        ],
      ),
    );
  }
}

getTime(int hours, int min, BuildContext context){
  
  TimeOfDay _time = TimeOfDay.now().add(hour: hours, minute: min);

  return _time.format(context);
}
extension TimeOfDayExtension on TimeOfDay {
  TimeOfDay add({int hour = 0, int minute = 0}) {
    print(hour);
    for(int i =0; ((this.minute + minute) >= 60); i++){
      hour++;
      minute = minute - (60 - this.minute);
    }
    
    if(this.hour + hour >= 24){
      hour = - (this.hour ) + ((this.hour + hour) - 24);
      
    }
    
    return this.replacing(hour: this.hour + hour, minute: this.minute + minute);
  }
}