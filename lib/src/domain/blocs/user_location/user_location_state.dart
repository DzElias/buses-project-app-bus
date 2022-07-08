part of 'user_location_bloc.dart';

abstract class UserLocationState extends Equatable {
  const UserLocationState();
  
  @override
  List<Object> get props => [];
}

class UserLocationLoading extends UserLocationState {}
class UserLocationLoaded extends UserLocationState {
  final double latitude;
  final double longitude;

  const UserLocationLoaded({required this.latitude, required this.longitude});


}

