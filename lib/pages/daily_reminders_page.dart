import 'package:bustracking/widgets/daily_reminder.dart';
import 'package:bustracking/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DailyRemindersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              Text(
                'Recordatorios Diarios',
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.black87,
                    fontFamily: 'Betm-Medium',
                    fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, 'set-daily-reminder-page');
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.blueAccent,
                  )),
            ],
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.white),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        drawer: MainDrawer(),
        body: Container(
          child: ListView(
            children: [
              DailyReminder(
                busName: 'Linea 270 Mburucuya Poty',
                reminderTime: '2 min ',
                busStopName: 'Ciudad nueva',
                reminderDays: 'Lunes, Martes, Jueves, Sabado',
              ),
              DailyReminder(
                busName: 'Linea 270 Mburucuya Poty',
                reminderTime: '2 min ',
                busStopName: 'Ciudad nueva',
                reminderDays: 'Lunes, Martes, Jueves, Sabado',
              ),
             DailyReminder(
                busName: 'Linea 270 Mburucuya Poty',
                reminderTime: '2 min ',
                busStopName: 'Ciudad nueva',
                reminderDays: 'Lunes, Martes, Jueves, Sabado',
              ),
              
            ],
          ),
        ));
  }
}
