part of 'bus_travel_bloc.dart';

abstract class BusTravelEvent extends Equatable {
  const BusTravelEvent();

  @override
  List<Object> get props => [];
}

class InitTravelEvent extends BusTravelEvent {
  final String busId;
  final BuildContext context;

  InitTravelEvent(this.busId, this.context);
}

class EndTravelEvent extends BusTravelEvent {
  final String busId;
  final BuildContext context;

  EndTravelEvent(this.busId, this.context);
}

class ChangeNextStopEvent extends BusTravelEvent {
  final BuildContext context;
  final String nextStopId;
  final String busId;

  const ChangeNextStopEvent(this.context, this.nextStopId, this.busId);
}
