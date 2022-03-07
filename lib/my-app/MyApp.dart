import 'package:bustracking/bloc/map/map_bloc.dart';
import 'package:bustracking/bloc/my_location/my_location_bloc.dart';
import 'package:bustracking/bloc/search/search_bloc.dart';
import 'package:bustracking/routes.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../services/socket_service.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData windowData = MediaQueryData.fromWindow(WidgetsBinding.instance!.window);
    windowData = windowData.copyWith(
      textScaleFactor: windowData.textScaleFactor > 1.0 ? 1.0 : windowData.textScaleFactor,
    );

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SocketService()),
          BlocProvider(create: (_) => MyLocationBloc()),
          BlocProvider(create: (_) => SearchBloc()),
          BlocProvider(create: (_) => MapBloc()),
        ],
        child: MediaQuery(
          data: windowData,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Bus Tracking App',
            initialRoute: 'nearby-bus-stop-page',
            routes: appRoutes,
          ),
        ));
  }
}