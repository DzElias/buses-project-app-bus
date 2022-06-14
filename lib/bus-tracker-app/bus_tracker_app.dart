import 'package:bustracking/bloc/travel/travel_bloc.dart';
import 'package:bustracking/bloc/buses/buses_bloc.dart';
import 'package:bustracking/bloc/map/map_bloc.dart';
import 'package:bustracking/bloc/my_location/my_location_bloc.dart';
import 'package:bustracking/bloc/search/search_bloc.dart';
import 'package:bustracking/bloc/stops/stops_bloc.dart';
import 'package:bustracking/routes.dart';
import 'package:bustracking/services/bus_service.dart';
import 'package:bustracking/services/socket_service.dart';
import 'package:bustracking/services/stops_service.dart';
import 'package:bustracking/services/traffic_service.dart';

import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData windowData = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    windowData = windowData.copyWith(
      textScaleFactor: windowData.textScaleFactor > 1.0 ? 1.0 : windowData.textScaleFactor,
    );

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SocketService()..socket.connect()),
          BlocProvider(create: (_) => MyLocationBloc()),
          BlocProvider(create: (_) => SearchBloc(trafficService: TrafficService())),
          BlocProvider(create: (_) => MapBloc()),
          BlocProvider(create: (_) => StopsBloc(stopService: StopService())),
          BlocProvider(create: (_) => BusesBloc(busService: BusService())),
          BlocProvider(create: (_) => TravelBloc()),
        ],
        child: Builder(builder: (context) {
          return MediaQuery(
            data: windowData,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Bus Tracking App',
              initialRoute: 'nearby-bus-stop-page',
              routes: appRoutes,
            ),
          );
        }));
  }

  
}
