import 'package:bustracking/main.dart';
import 'package:bustracking/pages/nearby-bus-stop-page/widgets/nearby_bus_stops_map.dart';
import 'package:bustracking/commons/widgets/custom-appbar.dart';
import 'package:bustracking/pages/nearby-bus-stop-page/widgets/custom-card.dart';
import 'package:bustracking/commons/widgets/main_drawer.dart';
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
      extendBodyBehindAppBar: true,
        appBar: CustomAppBar(
          title: Text(
            'Buscar Buses',
            style: TextStyle(
                fontSize: 17, color: Colors.black87, fontFamily: 'Betm-Medium', fontWeight: FontWeight.bold),
          ),centerTitle: true,),
        drawer: MainDrawer(),
        body: Stack(
          
          children: [
            
            Center(child: Text('Mapa'),),
            searchBusContainer(),
          ],
        ));
  }

  Container searchBusContainer() {
    return Container(
                margin: const EdgeInsets.only(top: 90),
                child: Align(
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
              );
  }
}
