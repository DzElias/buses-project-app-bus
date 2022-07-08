
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:me_voy_chofer/src/data/services/location_permissions_service.dart';
import 'package:me_voy_chofer/src/domain/entities/permission_status.dart';

part 'location_permission_event.dart';
part 'location_permission_state.dart';

class LocationPermissionBloc extends Bloc<LocationPermissionEvent, LocationPermissionState> {
  final LocationPermissionService _locationPermissionService;
  late StreamSubscription streamSubscription;
  LocationPermissionBloc(this._locationPermissionService) : super(const CheckingPermissionsState()) {

    on<CheckPermissionEvent>((event, emit) async {
      PermissionStatus permissionStatus = await _locationPermissionService.checkPermissions();
      if(event.serviceStatus == ServiceStatus.disabled){
        if(permissionStatus == PermissionStatus.granted || permissionStatus == PermissionStatus.always || permissionStatus == PermissionStatus.whileInUse){
          emit(const LocationIsDisabledState());
        }else {
          emit(const LocationPermissionIsDeniedState());
        }
      }else{
        if(permissionStatus == PermissionStatus.granted || permissionStatus == PermissionStatus.always || permissionStatus == PermissionStatus.whileInUse){
          emit(const LocationPermissionIsGrantedAndLocationIsEnabledState());
        }else {
          emit(const LocationPermissionIsDeniedState());
        }
       
      }
    });

    on<TapPermissionsButtonEvent>((event, emit)async {
      if(state is LocationPermissionIsDeniedState){
        PermissionStatus permissionStatus = await _locationPermissionService.checkPermissions();
        if(permissionStatus == PermissionStatus.denied ){
          PermissionStatus permissionStatus = await requestLocationPermission();
          if(permissionStatus == PermissionStatus.deniedForever){
            openAppSettings();
          }
        }
      }else if(state is LocationIsDisabledState){
        openLocationSettings();
      }
    });
    
    
    on<InitCheckingEvent>((event, emit) async{
      bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
      ServiceStatus serviceStatus = isLocationEnabled ? ServiceStatus.enabled : ServiceStatus.disabled;
      add(CheckPermissionEvent(serviceStatus));

      streamSubscription = Geolocator.getServiceStatusStream().listen((status) { 
        add(CheckPermissionEvent(status));
      });
    });

 


  }



  void openAppSettings() => _locationPermissionService.openAppSettings();

  void openLocationSettings() => _locationPermissionService.openLocationSettings();

  Future<PermissionStatus> requestLocationPermission() async => await _locationPermissionService.requestPermission();

  
}
