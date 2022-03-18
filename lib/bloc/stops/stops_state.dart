part of 'stops_bloc.dart';

class StopsState extends Equatable {
  final List<BusStop> stops;

  const StopsState({
    this.stops = const [],
  });

  StopsState copyWith({
    List<BusStop>? stops,
  }) =>
      StopsState(
        stops: stops ?? this.stops,
      );

  @override
  List<Object> get props => [stops];
}
