import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

part 'user_location_event.dart';
part 'user_location_state.dart';

class UserLocationBloc extends Bloc<UserLocationEvent, UserLocationState> {
  late StreamSubscription subscription;
  UserLocationBloc() : super(UserLocationLoading()) {
    on<StartFollowingEvent>((event, emit)async{
      const geoLocatorOptions = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 20
      );

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best,);
      add( LocationChangedEvent(latitude: position.latitude, longitude: position.longitude) );

      subscription = Geolocator.getPositionStream(locationSettings: geoLocatorOptions).listen((Position _position) { 
        add( LocationChangedEvent(latitude: _position.latitude, longitude: _position.longitude) );
      });

    });

    on<LocationChangedEvent>((event, emit){
      emit(UserLocationLoading());
      emit(UserLocationLoaded(latitude: event.latitude, longitude: event.longitude));
    });
  }
}
