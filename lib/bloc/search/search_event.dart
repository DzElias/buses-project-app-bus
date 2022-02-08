part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class OnEnableManualMarker extends SearchEvent{}

class OnDisableManualMarker extends SearchEvent{}

