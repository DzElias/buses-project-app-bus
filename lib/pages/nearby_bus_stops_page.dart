import 'package:bustracking/map/map.dart';
import 'package:bustracking/widgets/custom-card.dart';
import 'package:bustracking/widgets/custom-appbar.dart';
import 'package:bustracking/widgets/main_drawer.dart';
import 'package:flutter/material.dart';

class NearbyBusStopPage extends StatefulWidget {
  const NearbyBusStopPage({Key? key}) : super(key: key);

  @override
  State<NearbyBusStopPage> createState() => _NearbyBusStopPageState();
}

class _NearbyBusStopPageState extends State<NearbyBusStopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: const CustomAppBar(
          centerTitle: true,
          title: Text(
            'Paradas de Buses Cercanas',
            style: TextStyle(
                fontSize: 17,
                color: Colors.black87,
                fontFamily: 'Betm-Medium',
                fontWeight: FontWeight.bold),
          ),
        ),
        drawer: MainDrawer(),
        body: Stack(
          children: [
            MapPage(),
            
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                addDestinationButton(),
                busStopsContainer(),
              ],
            ),
          ],
        ));
  }

  addDestinationButton() {
    return Container(
      margin: const EdgeInsets.only(top: 90),
      child: ElevatedButton(
        onPressed: () {
          //Enviar datos de parada
          Navigator.pushNamed(context, 'add-destination');
        },
        child: Container(
          width: 300,
          height: 50,
          child: Row(children: const [
            Icon(
              Icons.location_pin,
              color: Colors.blueAccent,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Toca para agregar destino',
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
    );
  }
}

busStopsContainer() {
  return Container(
    margin: const EdgeInsets.only(bottom: 30, left: 30),
    height: 90,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: const [
        CustomCard(
          stopName: 'Terminal Km 9',
          distance: '3 km ',
          time: '(5 min)',
        ),
        CustomCard(
          stopName: 'Terminal Km 9',
          distance: '3 km ',
          time: '(5 min)',
        ),
        CustomCard(
          stopName: 'Terminal Km 9',
          distance: '3 km ',
          time: '(5 min)',
        ),
        CustomCard(
          stopName: 'Terminal Km 9',
          distance: '3 km ',
          time: '(5 min)',
        ),
      ],
    ),
  );
}
