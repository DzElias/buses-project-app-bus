import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:me_voy_chofer/src/data/services/socket_service.dart';
import 'package:me_voy_chofer/src/domain/blocs/auth/auth_bloc.dart';
import 'package:me_voy_chofer/src/domain/blocs/bus/bus_bloc.dart';
import 'package:me_voy_chofer/src/domain/blocs/location_permissions/location_permission_bloc.dart';
import 'package:me_voy_chofer/src/domain/blocs/stop/stop_bloc.dart';
import 'package:me_voy_chofer/src/ui/pages/navigation-page/navigation_page.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    final stopsBloc = Provider.of<StopBloc>(context, listen: false);
    final busesBloc = Provider.of<BusBloc>(context, listen: false);
    final socket = Provider.of<SocketService>(context, listen: false).socket;

    socket.connect();
    socket.on('loadStops', (data) => stopsBloc.add(SaveStopsEvent(data)));
    socket.on('loadBuses', (data) => busesBloc.add(SaveBusesEvent(data)));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusBloc, BusState>(
      builder: (context, busesState) {
        return BlocBuilder<StopBloc, StopState>(
          builder: (context, stopState) {
            if (busesState is BusesLoadedState && stopState is StopsLoadedState) {
              return BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authBlocState) {
                  if (authBlocState is! AuthInitial) {
                    return BlocBuilder<LocationPermissionBloc, LocationPermissionState>(
                      builder: (context, locationPermissionState) {
                        if (locationPermissionState is! CheckingPermissionsState) {
                          if (locationPermissionState is! LocationPermissionIsGrantedAndLocationIsEnabledState) {
                            Future.delayed(Duration.zero, () {
                              Navigator.pushReplacementNamed(context, 'location-permission-page');
                              Future.delayed(const Duration(seconds: 1)).then((value) => FlutterNativeSplash.remove());
                            });
                          } else {
                            if (authBlocState is UserIsAuthenticatedState) {
                              Future.delayed(Duration.zero).then((value) {
                                final bus = busesState.buses.firstWhere((element) => element.id == authBlocState.busId);
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => NavigationPage(bus: bus)));
                                return FlutterNativeSplash.remove();
                              });
                            }

                            if (authBlocState is UserIsNotAuthenticatedState) {
                              Future.delayed(Duration.zero).then((value) {
                                Navigator.pushReplacementNamed(context, 'login-page');
                                return FlutterNativeSplash.remove();
                              });
                            }
                          }
                        } else {
                          //CHECKING PERMISSIONS

                        }

                        return Container();
                      },
                    );
                  }
                  return Container();
                },
              );
            }
            return Container();
          },
        );
      },
    );
  }
}
