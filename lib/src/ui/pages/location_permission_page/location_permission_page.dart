import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:me_voy_chofer/src/domain/blocs/auth/auth_bloc.dart';
import 'package:me_voy_chofer/src/domain/blocs/bus/bus_bloc.dart';
import 'package:me_voy_chofer/src/domain/blocs/location_permissions/location_permission_bloc.dart';

import 'package:me_voy_chofer/src/ui/pages/location_permission_page/widgets/request_permission_button.dart';
import 'package:me_voy_chofer/src/ui/pages/navigation-page/navigation_page.dart';
import 'package:provider/provider.dart';

class LocationPermissionPage extends StatefulWidget {
  const LocationPermissionPage({Key? key}) : super(key: key);

  @override
  State<LocationPermissionPage> createState() => _LocationPermissionPageState();
}

class _LocationPermissionPageState extends State<LocationPermissionPage> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed) {
      Provider.of<LocationPermissionBloc>(context, listen: false).add(InitCheckingEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('assets/images/undraw_map_location.png'),
              width: 300,
              height: 300
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Column(
                children: const [
                  Text('¿Dónde te encuentras?', style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,

                  )),
                  SizedBox(height: 20,),
                  Text("Configura tu ubicacion para que podamos", style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54

                  )),
                  SizedBox(height: 10,),
                  Text("brindarte una mejor experiencia", style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54

                  ),),
                ],
              ),
            ),
            
            BlocBuilder<LocationPermissionBloc, LocationPermissionState>(
              builder: (context, locationPermissionstate) {
                if(locationPermissionstate is LocationPermissionIsGrantedAndLocationIsEnabledState) {
                  return BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, authBlocState) {
                        if(authBlocState is! AuthInitial){
                          return BlocBuilder<BusBloc, BusState>(
                            builder: (context, busesState) {
                              if(busesState is BusesLoadedState){
                                if (authBlocState is UserIsAuthenticatedState) {
                                  Future.delayed(Duration.zero).then((value) {
                                    final bus = busesState.buses.firstWhere((element) => element.id == authBlocState.busId);
                                    return Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => NavigationPage(bus: bus)));
                                  });
                                }

                                if (authBlocState is UserIsNotAuthenticatedState) {
                                  Future.delayed(Duration.zero).then((value) {
                                    return Navigator.pushReplacementNamed(context, 'login-page');
                                  });
                                }
                              }
                              return Container();
                            },
                          );
                        }

                        //Crear un loading page para no quedar en esta pagina por mucho tiempo
                      return Container();
                    },
                  );
                };
                return const RequestPermissionButton();
              },
      ),
          ],
        ),
    ));
  }
}
