part of 'bus_travel_bloc.dart';

abstract class BusTravelEvent extends Equatable {
  const BusTravelEvent();

  @override
  List<Object> get props => [];
}

class InitTravelEvent extends BusTravelEvent {}
class EndTravelEvent extends BusTravelEvent {}
class ChangeNextStopEvent extends BusTravelEvent {
  final BuildContext context;
  final String nextStopId;
  final String busId;

  const ChangeNextStopEvent(this.context, this.nextStopId, this.busId);
}