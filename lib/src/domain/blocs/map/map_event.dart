part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class MapLoadedEvent extends MapEvent {
  final MapController controller;
  final LatLng center;

  

  const MapLoadedEvent(this.controller, this.center);
}

