import 'package:bloc/bloc.dart';
import 'package:user_app/commons/models/stop.dart';
import 'package:equatable/equatable.dart';

part 'stops_event.dart';
part 'stops_state.dart';

class StopsBloc extends Bloc<StopsEvent, StopsState> {
  StopsBloc() : super(StopsState()) {
    on<OnStopsFoundEvent>((event, emit) => emit(state.copyWith(stops: event.stops)));
  }

  loadStops(dynamic response) async {
    List<Stop> stops = [];
    for(var map in response){
      Stop.fromMap(map);
    }
    add(OnStopsFoundEvent(stops));
  }
}
