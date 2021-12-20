import 'package:bustracking/main.dart';
import 'package:bustracking/map/map.dart';
import 'package:bustracking/widgets/bus_widget.dart';
import 'package:bustracking/widgets/custom-appbar.dart';
import 'package:bustracking/widgets/panel_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BusStopPage extends StatefulWidget {
  @override
  State<BusStopPage> createState() => _BusStopPageState();
}

class _BusStopPageState extends State<BusStopPage> {
  static const double fabHeightClosed = 100.0;
  double fabHeight = fabHeightClosed;

  final panelController = PanelController();
  @override
  Widget build(BuildContext context) {
    final panelHeightClosed = MediaQuery.of(context).size.height * 0.1;
    final panelHeightOpen = MediaQuery.of(context).size.height * 0.5;
    return Scaffold(
      appBar: CustomAppBar(
        title: appbarTitle(),
      ),
      body: Stack(
        children: [
          MapPage(),
          slidingUpPanel(panelHeightOpen, panelHeightClosed),
        ],
      ),
    );
  }

  appbarTitle() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Terminal Km 9',
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.black87,
                  fontFamily: 'Betm-Medium',
                  fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text(
                  '3 km (5 min)',
                  style: TextStyle(
                      color: Colors.blue[600],
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.directions_walk,
                  size: 18,
                  color: Colors.blueAccent,
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Dr. Jose Gaspar Rodriguez de Francia ',
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
              panelContent: busesApproachingContainer(),
            ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        onPanelSlide: (position) => setState(() {
              final panelMaxScrollExtent = panelHeightOpen - panelHeightClosed;

              fabHeight = position * panelMaxScrollExtent + fabHeightClosed;
            }));
  }

  busesApproachingContainer() {
    return Column(
      children: [
        Container(
            alignment: Alignment.center,
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
            child: Text('Buses acercándose',
                style: TextStyle(
                  fontSize: 20,
                ))),
        Column(
          children: [
            BusWidget(
              busName: 'Linea 270 Mburucuya Poty',
              busRoutes: 'Km 7 Monday hasta Barrio 23 de Octubre',
              time: '05 min',
            ),
            BusWidget(
              busName: 'Linea 270 Mburucuya Poty',
              busRoutes: 'Km 7 Monday hasta Barrio 23 de Octubre',
              time: '05 min',
            ),
            BusWidget(
              busName: 'Linea 270 Mburucuya Poty',
              busRoutes: 'Km 7 Monday hasta Barrio 23 de Octubre',
              time: '05 min',
            ),
            BusWidget(
              busName: 'Linea 270 Mburucuya Poty',
              busRoutes: 'Km 7 Monday hasta Barrio 23 de Octubre',
              time: '05 min',
            ),
          ],
        ),
      ],
    );
  }
}
