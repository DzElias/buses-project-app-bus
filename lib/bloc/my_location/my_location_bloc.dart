import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

part 'my_location_event.dart';
part 'my_location_state.dart';



class MyLocationBloc extends Bloc<MyLocationEvent, MyLocationState> {
  MyLocationBloc() : super(MyLocationState()){
    on<OnLocationChange>((event,emit) => emit(state.copyWith(locationExist: true, location: event.location)));
    on<OnSw>((event, emit) => emit(state.copyWith(sw: true)));
  }

  StreamSubscription<Position>? positionStream;

  


  void startFollowing(){
    const geoLocatorOptions = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10
    );

   positionStream =  Geolocator.getPositionStream(locationSettings: geoLocatorOptions).listen((Position position) { 

      print(position);
      final newLocation = LatLng(position.latitude, position.longitude);
      add( OnLocationChange(newLocation) );
    });

    


  }

  void cancelFollowing(){
    positionStream?.cancel();
  }

  

  // @override
  // Stream<MyLocationState> mapEventToState(MyLocationEvent event) async* {

  //   if(event is OnLocationChange){
  //     yield state.copyWith(locationExist: true, location: event.location);
  //   }
  // }
}
