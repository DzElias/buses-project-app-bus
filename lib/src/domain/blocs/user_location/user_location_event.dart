part of 'user_location_bloc.dart';

abstract class UserLocationEvent extends Equatable {
  const UserLocationEvent();

  @override
  List<Object> get props => [];
}

class StartFollowingEvent extends UserLocationEvent {}

class LocationChangedEvent extends UserLocationEvent {
  final double latitude;
  final double longitude;

  const LocationChangedEvent({required this.latitude, required this.longitude});

}
