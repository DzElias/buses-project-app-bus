import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:latlong2/latlong.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapInitial()) {
    on<MapEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
