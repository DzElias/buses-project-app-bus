part of 'map_bloc.dart';

@immutable
abstract class MapEvent extends Equatable {
  const MapEvent();

  @override 
  List<Object> get props => [];
}

class OnMapInitializedEvent extends MapEvent{
  final MapController controller;
  const OnMapInitializedEvent(this.controller);
}


