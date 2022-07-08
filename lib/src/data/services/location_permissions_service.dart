import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:me_voy_chofer/src/domain/entities/permission_status.dart';

abstract class LocationPermissionService {

  Future<PermissionStatus> checkPermissions();
  Future<bool> openAppSettings();
  Future<bool> openLocationSettings();
  Future<PermissionStatus> requestPermission();
}

class GeolocatorPermissionService implements LocationPermissionService {


  @override
  Future<PermissionStatus> checkPermissions() async {
    final LocationPermission locationPermission = await Geolocator.checkPermission();
    if(locationPermission == LocationPermission.deniedForever){
      return PermissionStatus.deniedForever;
    }else if( locationPermission == LocationPermission.denied){
      return PermissionStatus.denied;
    }else if( locationPermission == LocationPermission.whileInUse ){
      return PermissionStatus.whileInUse;
    }else if( locationPermission == LocationPermission.always ){
      return PermissionStatus.always;
    }else {
      return PermissionStatus.unableToDetermine;
    }
  }

  
  @override
  Future<bool> openAppSettings() async {
    bool result = await Geolocator.openAppSettings(); 
    return result;
  }
  
  @override
  Future<bool> openLocationSettings() async {
    bool result = await Geolocator.openLocationSettings();
    return result;
  }
  
  @override
  Future<PermissionStatus> requestPermission() async {
    LocationPermission locationPermission = await Geolocator.requestPermission();
    if(locationPermission == LocationPermission.deniedForever){
      return PermissionStatus.deniedForever;
    }else if( locationPermission == LocationPermission.denied){
      return PermissionStatus.denied;
    }else if( locationPermission == LocationPermission.whileInUse ){
      return PermissionStatus.whileInUse;
    }else if( locationPermission == LocationPermission.always ){
      return PermissionStatus.always;
    }else {
      return PermissionStatus.unableToDetermine;
    }
  }
 
}