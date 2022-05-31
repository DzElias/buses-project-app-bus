part of 'travel_bloc.dart';

class TravelState extends Equatable {
  final bool waiting;
  final bool traveling;
  final bool isHere;
  final Bus? bus;
  final Stop? stop;
  List<String> stopsSelected = [];
  final LatLng? destino;
  

  TravelState({
    this.waiting = false,
    this.traveling = false,
    this.isHere = false,
    this.bus ,
    this.destino,
    this.stopsSelected = const [],
    this.stop
  });

  TravelState copyWith(
    {
    
    bool? waiting,
    bool? traveling,
    bool? isHere,
    Bus? bus,
    Stop? stop,
    List<String>? stopsSelected,
    LatLng? destino
    
    }) =>
      TravelState(
        waiting: waiting ?? this.waiting,
        traveling: traveling ?? this.traveling,
        isHere: isHere ?? this.isHere,
        bus: bus?? this.bus,
        stop: stop ?? this.stop,
        stopsSelected: stopsSelected?? this.stopsSelected,
        destino: destino?? this.destino
      );

  @override
  List<Object?> get props => [waiting, traveling, isHere, bus, stop, stopsSelected, destino];
}

