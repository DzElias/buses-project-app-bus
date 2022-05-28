part of 'travel_bloc.dart';

abstract class TravelEvent extends Equatable {
  const TravelEvent();

  @override
  List<Object> get props => [];
}

class OnWaitingEvent extends TravelEvent {
  final bool value;

  OnWaitingEvent(this.value);
}

class OnTravelingEvent extends TravelEvent {
  final bool value;

  OnTravelingEvent(this.value);
}

class OnIsHereEvent extends TravelEvent {
  final bool value;

  OnIsHereEvent(this.value);
}


