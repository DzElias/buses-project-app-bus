part of 'my_location_bloc.dart';

@immutable
abstract class MyLocationEvent {}

class OnLocationChange extends MyLocationEvent {

  final LatLng location;

  OnLocationChange(this.location);
  
}
class OnSw extends MyLocationEvent {}
