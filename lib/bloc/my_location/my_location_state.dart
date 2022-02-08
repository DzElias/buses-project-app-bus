part of 'my_location_bloc.dart';

@immutable
class MyLocationState {
  final bool following;
  final bool locationExist;
  final LatLng? location;

  MyLocationState( {this.following = true, this.locationExist = false, this.location});

  MyLocationState copyWith({
    bool? following,
    bool? locationExist,
    LatLng? location,
  }) =>
      new MyLocationState(
          following: following ?? this.following,
          locationExist: locationExist ?? this.locationExist,
          location: location ?? this.location);
}
