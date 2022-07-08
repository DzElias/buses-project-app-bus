part of 'bus_travel_bloc.dart';

abstract class BusTravelState extends Equatable {
  const BusTravelState();
  
  @override
  List<Object> get props => [];
}

class BusIsNotTravelingState extends BusTravelState {}
class BusIsTravelingState extends BusTravelState {}

