

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:meta/meta.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {

  late MapController mapController;
  late MapController mapController2;

  MapBloc() : super(const MapState()) {
    on<OnMapInitializedEvent>(_onInitMap );
    on<OnMap2InitializedEvent>(_onInitMap2 );
  }

  void _onInitMap(OnMapInitializedEvent event, Emitter<MapState> emit){

    mapController = event.controller;

    emit(state.copyWith(isMapInitialized: true));
  }

  void _onInitMap2(OnMap2InitializedEvent event, Emitter<MapState> emit){

    mapController2 = event.controller;
    emit(state.copyWith(isMapInitialized: false));
    emit(state.copyWith(isMapInitialized: true));
  }



  
}
