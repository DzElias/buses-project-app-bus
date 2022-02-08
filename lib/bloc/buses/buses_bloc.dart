import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'buses_event.dart';
part 'buses_state.dart';

class BusesBloc extends Bloc<BusesEvent, BusesState> {
  BusesBloc() : super(BusesInitial()) {
    on<BusesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
