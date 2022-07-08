part of 'internet_connection_bloc.dart';

abstract class InternetConnectionEvent extends Equatable {
  const InternetConnectionEvent();

  @override
  List<Object> get props => [];
}

class StartListenInternetConnection extends InternetConnectionEvent {}
class HandleConnectionStatus extends InternetConnectionEvent {
  final InternetConnectionStatus internetConnectionStatus;

  const HandleConnectionStatus(this.internetConnectionStatus);
}