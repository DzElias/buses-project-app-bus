import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapLoadingState()) {
    on<MapLoadedEvent>((event, emit) {
      var mapState = state;
      
      emit(MapLoadedState(center: event.center));
      
    });
  }

  void animatedMapMove(LatLng destLocation, double destZoom, TickerProvider tickerProvider, MapController mapController) {
    var mapState = state;
    
    if(mapState is MapLoadedState ) {
      
      
      final latTween = Tween<double>(begin: mapController.center.latitude, end: destLocation.latitude);
      final lngTween = Tween<double>( begin: mapController.center.longitude, end: destLocation.longitude);
      final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);
      
      var controller = AnimationController( duration: const Duration(milliseconds: 500), vsync: tickerProvider);

      Animation<double> animation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

      controller.addListener(() {
        mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation)
        );
      });

      animation.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.dispose();
        } else if (status == AnimationStatus.dismissed) {
          controller.dispose();
        }
      });

      controller.forward();
    }
  }  

  
}
