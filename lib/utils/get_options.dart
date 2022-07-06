import 'package:user_app/commons/models/bus.dart';
import 'package:user_app/commons/models/stop.dart';
import 'package:user_app/commons/models/places_response.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class Option 
{

  final Stop paradaA;
  final Bus bus;
  final Stop paradaB;

  Option({ 
    required this.paradaA, 
    required this.bus, 
    required this.paradaB 
  });

}

class DestinationService {
  final LatLng userLocation;
  final LatLng destination;
  final List<Bus> buses;
  final List<Stop> stops;

  DestinationService({
    required this.buses,
    required this.stops,
    required this.userLocation,
    required this.destination
  });

  


  List<Option> getOptions()
  {

    List<Option> options = [];

    List<Stop> stopsCloseUser = _getClosestStops(userLocation);
    List<Stop> stopsCloseDestination = _getClosestStops(destination);

    if( stopsCloseUser.isEmpty | stopsCloseDestination.isEmpty )
    {
      return [];
    }

    for (Stop stopUser in stopsCloseUser)
    {
      List<Bus> busesArriving = _getBusesArriving(stopUser);
      
      if(busesArriving.isNotEmpty)
      {
        for(Bus bus in busesArriving)
        {
          for(Stop stopDest in stopsCloseDestination)
          {
            if(_itsComing(stopDest, bus, stopUser.id))
            {

              Option option = Option( paradaA: stopUser, bus: bus, paradaB: stopDest );
              options.add(option);

            }
          }
        }
      }

    }

    return options;

  }
  
  List<Bus> _getBusesArriving( Stop stop )
  {

    List<Bus> busesArriving = [];

    for(Bus bus in buses)
    {
      if( _itsComing(stop, bus, bus.nextStop) )
      {
        busesArriving.add(bus);
      }
    }

    return busesArriving;

  }

  

  bool _itsComing( Stop stop1, Bus bus, String stop2ID )
  {

    int index = bus.stops.indexWhere((element) => element == stop2ID);

    if(index >= 0)
    {

      for(int i = index; i<bus.stops.length; i++)
      {
        if(bus.stops[i] == stop1.id)
        {
          return true;
        }
      }
    }
    
    return false;

  }

  List<Stop> _getClosestStops(LatLng point) 
  {

    List<Stop> closestStops = [];

    for (Stop stop in stops) 
    {

      LatLng stopLocation = LatLng(stop.latitude, stop.longitude);

      if(_calculateDistance(point, stopLocation) < 250)
      {
        closestStops.add(stop);
      }

    }

    return closestStops;

  }

  int _calculateDistance(LatLng point1, LatLng point2) {
    
    var _distanceInMeters = Geolocator.distanceBetween( point1.latitude, point1.longitude, point2.latitude, point2.longitude );

    int distance = _distanceInMeters.round();

    return distance;

  }
}
