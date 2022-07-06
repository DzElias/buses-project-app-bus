import 'package:user_app/bloc/travel/travel_bloc.dart';
import 'package:user_app/bloc/buses/buses_bloc.dart';
import 'package:user_app/bloc/map/map_bloc.dart';
import 'package:user_app/bloc/my_location/my_location_bloc.dart';
import 'package:user_app/bloc/search/search_bloc.dart';
import 'package:user_app/bloc/stops/stops_bloc.dart';
import 'package:user_app/routes.dart';
import 'package:user_app/services/socket_service.dart';
import 'package:user_app/services/traffic_service.dart';

import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
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
          BlocProvider(create: (_) => StopsBloc()),
          BlocProvider(create: (_) => BusesBloc()),
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
