part of 'location_permission_bloc.dart';

abstract class LocationPermissionEvent extends Equatable {
  const LocationPermissionEvent();

  @override
  List<Object> get props => [];
}

class CheckPermissionEvent extends LocationPermissionEvent {
  final ServiceStatus serviceStatus;

  const CheckPermissionEvent(this.serviceStatus); 
}

class TapPermissionsButtonEvent extends LocationPermissionEvent {}

class InitCheckingEvent extends LocationPermissionEvent {}

