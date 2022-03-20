import 'package:bustracking/bus-tracker-app/bus_tracker_app.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/services.dart';

void main() async {
  await Future.delayed(const Duration(seconds: 3));
  runApp(const MyApp());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}
