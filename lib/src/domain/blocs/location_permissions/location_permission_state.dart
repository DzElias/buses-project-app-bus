part of 'location_permission_bloc.dart';

abstract class LocationPermissionState extends Equatable {
  
  const LocationPermissionState();
  @override
  List<Object> get props => [];
}

class CheckingPermissionsState extends LocationPermissionState {
  const CheckingPermissionsState();
}

class LocationPermissionIsGrantedAndLocationIsEnabledState extends LocationPermissionState {
  const LocationPermissionIsGrantedAndLocationIsEnabledState();
}

class LocationPermissionIsDeniedState extends LocationPermissionState {
  const LocationPermissionIsDeniedState();
}

class LocationIsDisabledState extends LocationPermissionState {
  const LocationIsDisabledState();
}



