import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchState()) {


    on<OnEnableManualMarker>((event, emit){

      emit(
        state.copyWith( manualSelection: true)
      );
      // TODO: implement event handler
    });

    on<OnDisableManualMarker>((event, emit){

      emit(
        state.copyWith( manualSelection: false)
      );
      // TODO: implement event handler
    });



    
  }
}
