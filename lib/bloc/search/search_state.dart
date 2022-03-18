part of 'search_bloc.dart';

class SearchState extends Equatable {
  final bool manualSelection;
  final List<Feature> places;
  final List<Feature> history;

  const SearchState({
    this.manualSelection = false,
    this.places = const [],
    this.history = const [],
  });

  SearchState copyWith(
          {bool? manualSelection,
          List<Feature>? places,
          List<Feature>? history}) =>
      SearchState(
        manualSelection: manualSelection ?? this.manualSelection,
        places: places ?? this.places,
        history: history ?? this.history,
      );

  @override
  List<Object> get props => [manualSelection, places, history];
}
