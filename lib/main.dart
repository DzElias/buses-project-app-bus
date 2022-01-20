import 'dart:async';

import 'package:bustracking/routes.dart';
import 'package:bustracking/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData windowData =
        MediaQueryData.fromWindow(WidgetsBinding.instance!.window);
    windowData = windowData.copyWith(
      textScaleFactor:
          windowData.textScaleFactor > 1.0 ? 1.0 : windowData.textScaleFactor,
    );
    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => SocketService())],
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
