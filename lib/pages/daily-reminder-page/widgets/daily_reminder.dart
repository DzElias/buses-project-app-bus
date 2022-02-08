import 'package:flutter/material.dart';

class DailyReminder extends StatelessWidget {
  final String busName;
  final String reminderTime;
  final String reminderDays;
  final String busStopName;

  const DailyReminder(
      {Key? key,
      required this.busStopName,
      required this.reminderTime,
      required this.reminderDays,
      required this.busName})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      
      margin: EdgeInsets.only(top: 20, right: 10, left: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ]),
      child: Column(
        children: [
          ListTile(
              leading: Icon(
                Icons.directions_bus,
                color: Colors.green,
                size: 22,
              ),
              title: Text(this.busName,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              trailing: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, 'set-daily-reminder-page');
                  },
                  child: Icon(Icons.edit))),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Recuerdame '),
                    Text(
                      this.reminderTime,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('antes de '),
                    Text(
                      this.busStopName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                //Text('Remind me 2 min before Old Sawmill'),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Los dias '),
                    Text(this.reminderDays,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
