import 'package:bloc/bloc.dart';
import 'package:bustracking/commons/models/busStop.dart';
import 'package:bustracking/services/stops_service.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'stops_event.dart';
part 'stops_state.dart';

class StopsBloc extends Bloc<StopsEvent, StopsState> {
  StopService stopService;
  StopsBloc({required this.stopService}) : super(StopsState()) {
    on<OnStopsFoundEvent>(
        (event, emit) => emit(state.copyWith(stops: event.stops)));
  }

  Future getStops() async {
    final stops = await stopService.getStops();
    add(OnStopsFoundEvent(stops));
  }
}
