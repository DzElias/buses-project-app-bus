import 'package:bustracking/map/map.dart';
import 'package:bustracking/widgets/bus-route.dart';
import 'package:bustracking/widgets/custom-appbar.dart';
import 'package:bustracking/widgets/panel_widget.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BusPage extends StatefulWidget {
  @override
  State<BusPage> createState() => _BusPageState();
}

class _BusPageState extends State<BusPage> {
  static const double fabHeightClosed = 100.0;
  double fabHeight = fabHeightClosed;

  final panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    final panelHeightClosed = MediaQuery.of(context).size.height * 0.1;
    final panelHeightOpen = MediaQuery.of(context).size.height * 0.53;
    return Scaffold(
        appBar: CustomAppBar(
          title: appbarTitle(),
        ),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            MapPage(),
            slidingUpPanel(panelHeightOpen, panelHeightClosed),
            Positioned(right: 20, bottom: fabHeight, child: waitButton())
          ],
        ));
  }

  appbarTitle() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Linea 270 Mburucuya Poty',
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.black87,
                  fontFamily: 'Betm-Medium',
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Km 7 Monday hasta Barrio 23 de Octubre',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black45,
                  fontFamily: 'Betm-Medium',
                  fontWeight: FontWeight.bold),
            ),
          ],
        )
      ],
    );
  }

  slidingUpPanel(double panelHeightOpen, double panelHeightClosed) {
    return SlidingUpPanel(
        controller: panelController,
        maxHeight: panelHeightOpen,
        minHeight: panelHeightClosed,
        parallaxEnabled: true,
        parallaxOffset: .5,
        

        panelBuilder: (controller) => PanelWidget(
              panelController: panelController,
              controller: controller,
              panelContent: Column(
                children: [
                  Column(
                    children: [
                      Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Text('Ruta del Bus',
                              style: TextStyle(
                                fontSize: 20,
                              ))),
                      Column(
                        children: [
                          BusRoute(
                            onn: false,
                            directionName: 'Km 7 Monday',
                            checkIn: '12:20',
                          ),
                          BusRoute(
                            onn: false,
                            directionName: 'Barrio Ciudad Nueva',
                            checkIn: '12:24',
                          ),
                          BusRoute(
                            onn: true,
                            directionName: 'Barrio San Jose',
                            checkIn: '12:35',
                          ),
                          BusRoute(
                            onn: true,
                            directionName: 'Barrio Santa Ana',
                            checkIn: '12:45',
                          ),
                          BusRoute(
                            onn: true,
                            directionName: 'Barrio 23 de octubre',
                            checkIn: '12:50',
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        onPanelSlide: (position) => setState(() {
              final panelMaxScrollExtent = panelHeightOpen - panelHeightClosed;

              fabHeight = position * panelMaxScrollExtent + fabHeightClosed;
            }));
  }

  waitButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.blueAccent,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(20.0),
          ),
        ),
        onPressed: () {},
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.hourglass_empty),
              Text(
                'Esperar aqui',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ));
  }
}
