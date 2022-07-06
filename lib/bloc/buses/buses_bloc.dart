import 'package:bloc/bloc.dart';
import 'package:user_app/commons/models/bus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/Material.dart';

part 'buses_event.dart';
part 'buses_state.dart';

class BusesBloc extends Bloc<BusesEvent, BusesState> {
  BusesBloc() : super(BusesState()) {
    on<OnBusesFoundEvent>(
        (event, emit) => emit(state.copyWith(buses: event.buses)));
    on<OnBusUpdateEvent>((event, emit) {
      final buses = state.buses;
      int index = buses.indexWhere((element) => element.id == event.id);
      if (index >= 0) {
        buses[index].latitude = event.lat;
        buses[index].longitude = event.long;

        emit(state.copyWith(buses: buses));
      }
    });
  }

  loadBuses(dynamic response) async {
    List<Bus> buses = [];
    for(var map in response){
      Bus.fromMap(map);
    }


    add(OnBusesFoundEvent(buses));
  }

  handleBusLocation(dynamic payload) {
    final buses = state.buses;
    int index = buses.indexWhere((element) => element.id == payload[0]);
    if (index >= 0) {
      String lat = payload[1];
      String long = payload[2];
      buses[index].latitude = double.parse(lat);
      buses[index].longitude = double.parse(long);

      add(OnBusesFoundEvent(buses));
    }
  }

  handleBusProxStop(dynamic payload) {
    final buses = state.buses;
    int index = buses.indexWhere((element) => element.id == payload[0]);

    if ( index >= 0){
      String proxStop = payload[1];
      buses[index].nextStop = proxStop;

      add(OnBusesFoundEvent(buses));

    }
  }
}
