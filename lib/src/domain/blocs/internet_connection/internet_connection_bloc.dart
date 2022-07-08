import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'internet_connection_event.dart';
part 'internet_connection_state.dart';

class InternetConnectionBloc extends Bloc<InternetConnectionEvent, InternetConnectionState> {
  late StreamSubscription _streamSubscription; 
   InternetConnectionChecker internetConnectionChecker = InternetConnectionChecker();
  bool sw = false;
  InternetConnectionBloc() : super(InternetConnectionInitial()) {
    on<StartListenInternetConnection>((event, emit) async {
      _streamSubscription =  internetConnectionChecker.onStatusChange.listen((status) {
        add(HandleConnectionStatus(InternetConnectionStatus.connected));
      });
    });

    on<HandleConnectionStatus>((event, emit){
      if(event.internetConnectionStatus == InternetConnectionStatus.connected){
        emit(InternetConnectionEnabled());
      }else{
        emit(InternetConnectionDisabled());
      }
    });

  
}

  void disposeStreamSubscription()async {
    await _streamSubscription.cancel();
  }
}