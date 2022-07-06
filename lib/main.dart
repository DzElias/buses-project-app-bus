import 'package:user_app/app/app.dart';
import 'package:user_app/services/notification_service.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:flutter/Material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  NotificationService().initNotification();
  runApp(const App());                                         
    
  SystemChrome.setPreferredOrientations([ DeviceOrientation.portraitUp ]);

}
