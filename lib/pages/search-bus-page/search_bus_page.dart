import 'package:bustracking/bloc/buses/buses_bloc.dart';
import 'package:bustracking/commons/models/bus.dart';
import 'package:bustracking/commons/widgets/custom-appbar.dart';

import 'package:bustracking/commons/widgets/main_drawer.dart';
import 'package:bustracking/search/search_bus_delegate.dart';
import 'package:bustracking/utils/cachedTileProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoiZWxpYXNkaWF6MTAwNSIsImEiOiJja3d4eDQ3OTcwaHk3Mm51cjNmcWRvZjA2In0.AAF794oxyxFR_-wAvVwMfQ';
const MAPBOX_STYLE = 'mapbox/light-v10';

class SearchBus extends StatefulWidget {
  @override
  State<SearchBus> createState() => _SearchBusState();
}

class _SearchBusState extends State<SearchBus> with TickerProviderStateMixin {
  final mapController = MapController();

  String? id;
  bool track = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        // floatingActionButton: track ? cancelTrackBtn() : Container(),
        appBar: const CustomAppBar(
         backgroundColor:  Colors.white,
          title: Text(
            'Buscar Buses',
            style: TextStyle(
                fontSize: 17,
                color: Colors.black87,
                fontFamily: 'Betm-Medium',
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        drawer: MainDrawer(),
        body: Stack(
          children: [
            BlocBuilder<BusesBloc, BusesState>(
              builder: (context, state) {
                List<Bus> buses = state.buses;
                return FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                      center: LatLng(-25.5161428, -54.6418963),
                      zoom: 12,
                      minZoom: 6,
                      maxZoom: 16,
                      interactiveFlags:
                          InteractiveFlag.all & ~InteractiveFlag.rotate),
                  layers: [
                    TileLayerOptions(
                        urlTemplate:
                            "https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}",
                        additionalOptions: {
                          'accessToken': MAPBOX_ACCESS_TOKEN,
                          'id': MAPBOX_STYLE
                        },
                        tileProvider: const CachedTileProvider()),
                    MarkerLayerOptions(markers: getActiveBuses(buses)),
                  ],
                );
              },
            ),
            searchBusContainer(),
            track ? trackBus(id) : SizedBox(),
            track ? cancelTrackBtn() : Container(),
          ],
        ));
  }

  Container searchBusContainer() {
    return Container(
      margin: const EdgeInsets.only(top: 90),
      child: Align(
        alignment: Alignment.topCenter,
        child: ElevatedButton(
          onPressed: () async {
            var result = await showSearch(
              context: context,
              delegate: BusSearch(),
            );
            if (result != "") {
              setState(() {
                id = result;
                track = true;
              });
            }
          },
          child: SizedBox(
            width: 300,
            height: 60,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.directions_bus, color: Colors.green),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        !track
                            ? '¿Que bus estas buscando?'
                            : 'Linea ${busById(id).linea} ${busById(id).titulo} ',
                        style: TextStyle(
                          color: !track ? Colors.black45 : Colors.black54,
                        ),
                      )
                    ],
                  ),
                  Icon(
                    Icons.my_location,
                    color: !track ? Colors.black45 : Colors.red,
                  )
                ]),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
          ),
        ),
      ),
    );
  }

  List<Marker> getActiveBuses(List<Bus> buses) {
    List<Marker> markerList = [];
    for (var bus in buses) {
      markerList.add(Marker(
          width: 60,
          height: 60,
          point: LatLng(bus.latitud, bus.longitud),
          key: Key(bus.id),
          builder: (_) => const Center(
                  child: Image(
                image: AssetImage('assets/bus_point.png'),
              ))));
    }
    return markerList;
  }

  Widget trackBus(String? id) {
    return BlocBuilder<BusesBloc, BusesState>(builder: (context, state) {
      var buses = state.buses;
      int index = buses.indexWhere((element) => element.id == id);

      Bus bus = buses[index];

      var busLatLng = LatLng(bus.latitud, bus.longitud);

      double zoom = mapController.zoom;
      if (zoom < 16) {
        zoom = 16.0;
      }
      animatedMapMove(busLatLng, zoom);
      return Container();
    });
  }

  Widget cancelTrackBtn() {
    return Positioned(
      bottom: 30,
      right: 30,
      child: FloatingActionButton(
        onPressed: () {
          setState(() {
            track = false;
            id = "";
          });
        },
        elevation: 3,
        backgroundColor: Colors.red,
        child: Icon(
          Icons.gps_off_sharp,
          color: Colors.white,
        ),
      ),
    );
  }

  animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final _latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final _lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final _zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
          LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),
          _zoomTween.evaluate(animation));
    });
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  Bus busById(String? _id) {
    final buses = Provider.of<BusesBloc>(context, listen: false).state.buses;
    var i = buses.indexWhere((element) => element.id == _id);

    return buses[i];
  }
}
