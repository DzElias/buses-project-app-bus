part of 'travel_bloc.dart';

abstract class TravelEvent extends Equatable {
  const TravelEvent();

  @override
  List<Object> get props => [];
}

class OnWaitingEvent extends TravelEvent {
  final Bus bus;
  final Stop stop;
  final List<String> stopsSelected = [];
  final LatLng destino;

  OnWaitingEvent({ required this.bus,required this.stop, required this.destino});
}

class OnDesWaitingEvent extends TravelEvent{
}

class OnTravelingEvent extends TravelEvent {
  final Bus bus;
  final Stop stop;
  final List<String> stopsSelected = [];
  final LatLng destino;

  OnTravelingEvent({ required this.bus, required this.stop, required this.destino});
}

class OnDesTravelingEvent extends TravelEvent{}

class OnIsHereEvent extends TravelEvent {
  final bool value;

  OnIsHereEvent(this.value);
}


