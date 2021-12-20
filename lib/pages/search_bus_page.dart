import 'package:bustracking/main.dart';
import 'package:bustracking/widgets/custom-card.dart';
import 'package:bustracking/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchBus extends StatefulWidget {
  @override
  State<SearchBus> createState() => _SearchBusState();
}

class _SearchBusState extends State<SearchBus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Buscar Buses',
            style: TextStyle(
                fontSize: 17, color: Colors.black87, fontFamily: 'Betm-Medium', fontWeight: FontWeight.bold),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.white),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        drawer: MainDrawer(),
        body: SafeArea(
            child: Stack(
              
              children: [
                Center(child: Text('Mapa'),),
                Align(
                  alignment: Alignment.topCenter,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Container(
                      width: 300,
                      height: 60,
                      child: Row(children: [
                        Icon(
                          Icons.directions_bus,
                          color: Colors.green
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Ingresa el numero del bus',
                          style: TextStyle(
                            color: Colors.black45,
                          ),
                        ),
                      ]),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                    ),
                  ),
                ),
              ],
            )));
  }
}
