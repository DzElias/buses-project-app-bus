import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:me_voy_chofer/src/data/services/location_permissions_service.dart';
import 'package:me_voy_chofer/src/data/services/socket_service.dart';
import 'package:me_voy_chofer/src/domain/blocs/auth/auth_bloc.dart';
import 'package:me_voy_chofer/src/domain/blocs/bus/bus_bloc.dart';
import 'package:me_voy_chofer/src/domain/blocs/bus_travel/bus_travel_bloc.dart';
import 'package:me_voy_chofer/src/domain/blocs/map/map_bloc.dart';
import 'package:me_voy_chofer/src/domain/blocs/stop/stop_bloc.dart';
import 'package:me_voy_chofer/src/domain/blocs/user_location/user_location_bloc.dart';
import 'package:me_voy_chofer/src/domain/blocs/internet_connection/internet_connection_bloc.dart';
import 'package:me_voy_chofer/src/domain/blocs/location_permissions/location_permission_bloc.dart';
import 'package:me_voy_chofer/src/ui/pages/location_permission_page/location_permission_page.dart';
import 'package:me_voy_chofer/src/ui/pages/login_page/login_page.dart';
import 'package:me_voy_chofer/src/ui/pages/navigation-page/navigation_page.dart';
import 'package:me_voy_chofer/src/ui/pages/splash_page/splash_page.dart';

import 'package:provider/provider.dart';


class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData windowData = MediaQueryData.fromWindow(
        WidgetsBinding.instance.window
      );

    windowData = windowData.copyWith(
      textScaleFactor: windowData.textScaleFactor > 1.0 
      ? 1.0 
      : windowData.textScaleFactor,
    );

    SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketService()),
        BlocProvider(create: (_) => LocationPermissionBloc(GeolocatorPermissionService())..add(InitCheckingEvent())),
        BlocProvider(create: (_) => InternetConnectionBloc()),
        BlocProvider(create: (_) => UserLocationBloc()),
        BlocProvider(create: (_) => StopBloc()),
        BlocProvider(create: (_) => BusBloc()),
        BlocProvider(create: (_) => MapBloc(),),
        BlocProvider(create: (_) => AuthBloc(const FlutterSecureStorage())..add(CheckIfUserIsAuthenticatedEvent())),
        BlocProvider(create: (_) => BusTravelBloc()),
      ],
        child: MediaQuery(
          data: windowData,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Me voy',
            initialRoute: 'splash',
            routes: {
              'splash': (_) => const SplashPage(),
              'location-permission-page': (_) => const LocationPermissionPage(),
              'login-page': (_) => const LoginPage(),

            },
          ),
        ),
    );
  }
}