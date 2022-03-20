import 'package:bloc/bloc.dart';
import 'package:bustracking/commons/models/bus.dart';
import 'package:bustracking/services/bus_service.dart';
import 'package:equatable/equatable.dart';

part 'buses_event.dart';
part 'buses_state.dart';

class BusesBloc extends Bloc<BusesEvent, BusesState> {
  BusService busService;
  BusesBloc({required this.busService}) : super(BusesState()) {
    on<OnBusesFoundEvent>(
        (event, emit) => emit(state.copyWith(buses: event.buses)));
    on<OnBusUpdateEvent>((event, emit) {
      final buses = state.buses;
      int index = buses.indexWhere((element) => element.id == event.id);
      if (index >= 0) {
        buses[index].latitud = event.lat;
        buses[index].longitud = event.long;

        emit(state.copyWith(buses: buses));
      }
    });
  }

  Future getBuses() async {
    final buses = await busService.getBuses();
    add(OnBusesFoundEvent(buses));
  }

  handleBusLocation(dynamic payload) {
    add(OnBusUpdateEvent(payload[0], payload[1], payload[2]));
  }
}
