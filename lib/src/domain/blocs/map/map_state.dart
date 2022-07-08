// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'map_bloc.dart';

abstract class MapState extends Equatable {
  const MapState();
  
  @override
  List<Object> get props => [];
}

class MapLoadingState extends MapState {}

class MapLoadedState extends MapState {
  
  final LatLng center;

  const MapLoadedState({
    required this.center
  });

  MapLoadedState copyWith({
      LatLng? center,
    }) => MapLoadedState(
      center: center ?? this.center,
      
  );
}
