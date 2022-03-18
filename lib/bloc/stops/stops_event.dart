part of 'stops_bloc.dart';

abstract class StopsEvent extends Equatable {
  const StopsEvent();

  @override
  List<Object> get props => [];
}

class OnStopsFoundEvent extends StopsEvent {
  final List<BusStop> stops;
  const OnStopsFoundEvent(this.stops);
}
