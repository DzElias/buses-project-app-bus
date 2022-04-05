import 'package:bustracking/bus-tracker-app/bus_tracker_app.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:flutter/Material.dart';
import 'package:flutter/services.dart';

void main() async {
  
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  
  runApp(const MyApp());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}
