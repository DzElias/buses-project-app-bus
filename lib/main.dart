import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:me_voy_chofer/src/app.dart';

void main() async { 
  
  const androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: "Verificando ubicacion...",
    notificationText: "Estamos usando tu ubicacion!",
    notificationImportance: AndroidNotificationImportance.Default,
    notificationIcon: AndroidResource(name: 'ic_launcher', defType: 'mipmap'), // Default is ic_launcher from folder mipmap
  );

  

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await FlutterBackground.initialize(androidConfig: androidConfig);
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await FlutterBackground.enableBackgroundExecution();
  runApp(const App());
  
} 
