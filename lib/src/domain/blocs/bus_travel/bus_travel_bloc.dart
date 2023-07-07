import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:me_voy_chofer/src/data/services/socket_service.dart';
import 'package:provider/provider.dart';

part 'bus_travel_event.dart';
part 'bus_travel_state.dart';

class BusTravelBloc extends Bloc<BusTravelEvent, BusTravelState> {
  BusTravelBloc() : super(BusIsNotTravelingState()) {
    on<InitTravelEvent>((event, emit) {
      Provider.of<SocketService>(event.context, listen: false)
          .socket
          .emit('busOnWay', [event.busId]);
      emit(BusIsTravelingState());
    });
    on<EndTravelEvent>((event, emit) {
      Provider.of<SocketService>(event.context, listen: false)
          .socket
          .emit('busOffWay', [event.busId]);
      emit(BusIsNotTravelingState());
    });
    on<ChangeNextStopEvent>((event, emit) {
      var socket =
          Provider.of<SocketService>(event.context, listen: false).socket;
      socket.emit('change-nextStop', [
        [event.busId, event.nextStopId]
      ]);
    });
  }
}
