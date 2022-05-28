part of 'travel_bloc.dart';

class TravelState extends Equatable {
  final bool waiting;
  final bool traveling;
  final bool isHere;
  

  const TravelState({
    this.waiting = false,
    this.traveling = false,
    this.isHere = false,
  });

  TravelState copyWith(
    {
    
    bool? waiting,
    bool? traveling,
    bool? isHere,
    
    }) =>
      TravelState(
        waiting: waiting ?? this.waiting,
        traveling: traveling ?? this.traveling,
        isHere: isHere ?? this.isHere
      );

  @override
  List<Object> get props => [waiting, traveling, isHere];
}

