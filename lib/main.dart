
import 'package:bustracking/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
} 

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bus Tracking App',
      initialRoute: 'nearby-bus-stop-page',
      routes: appRoutes,
    );
  }
}