import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'travel_event.dart';
part 'travel_state.dart';

class TravelBloc extends Bloc<TravelEvent, TravelState> {
  TravelBloc() : super(TravelState()) {

    on<OnWaitingEvent>((event, emit) {

      emit(state.copyWith( waiting: event.value ));

    });

    on<OnTravelingEvent>((event, emit) {

      emit(state.copyWith( traveling: event.value ));

    });

    on<OnIsHereEvent>((event, emit) {

      emit(state.copyWith( isHere: event.value ));

    });
    
  }

  
}
