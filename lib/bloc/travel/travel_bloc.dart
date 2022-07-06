import 'package:bloc/bloc.dart';
import 'package:user_app/commons/models/bus.dart';
import 'package:user_app/commons/models/stop.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

part 'travel_event.dart';
part 'travel_state.dart';

class TravelBloc extends Bloc<TravelEvent, TravelState> {
  TravelBloc() : super(TravelState()) {

    on<OnWaitingEvent>((event, emit) {

      emit(state.copyWith( waiting: true, bus: event.bus, stop: event.stop, destino: event.destino, stopsSelected: event.stopsSelected ));

    });

    on<OnDesWaitingEvent>((event, emit){
      emit(state.copyWith( waiting: false, bus: null, stop: null, destino: null, stopsSelected: [] ));
    });

    on<OnDesTravelingEvent>((event, emit) {

      emit(state.copyWith( traveling: false, bus: null, stop: null, destino: null, stopsSelected: [] ));

    });

    on<OnTravelingEvent>((event, emit){
      emit(state.copyWith( traveling: true, bus: event.bus, stop: event.stop, destino: event.destino, stopsSelected: event.stopsSelected ));
    });

    on<OnIsHereEvent>((event, emit) {

      emit(state.copyWith( isHere: event.value ));

    });
    
  }

  
}