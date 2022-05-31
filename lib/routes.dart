import 'package:bustracking/pages/bus-page/view/bus_page.dart';
import 'package:bustracking/pages/bus-stop-page/view/bus_stop_page.dart';
import 'package:bustracking/pages/gps_access_page/view/gps_access_page.dart';
import 'package:bustracking/pages/nearby-bus-stop-page/view/nearby_bus_stops_page.dart';
import 'package:bustracking/pages/search-bus-page/search_bus_page.dart';

import 'package:flutter/Material.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {

  'nearby-bus-stop-page': (_) => const NearbyBusStopPage(),
  'bus-stop': (_) => BusStopPage(),
  'bus-page': (_) => BusPage(),
  'gps-access-page': (_) => const GpsAccessPage(),
  "search-bus": (_) =>  SearchBus()
};
