import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:me_voy_chofer/src/domain/entities/bus.dart';

part 'bus_event.dart';
part 'bus_state.dart';

class BusBloc extends Bloc<BusEvent, BusState> {
  BusBloc() : super(BusesLoadingState()) {
    on<SaveBusesEvent>((event, emit){
      List<Bus> buses = [];
      for(var map in event.payload){
        buses.add(Bus.fromMap(map));
      }
      emit(BusesLoadingState());
      emit(BusesLoadedState(buses));
    });
  }
}
