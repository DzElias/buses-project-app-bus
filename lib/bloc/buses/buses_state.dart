part of 'buses_bloc.dart';

class BusesState extends Equatable {
  final List<Bus> buses;

  const BusesState({
    this.buses = const [],
  });

  BusesState copyWith({
    List<Bus>? buses,
  }) =>
      BusesState(
        buses: buses ?? this.buses,
      );

  @override
  List<Object> get props => [buses];
}
