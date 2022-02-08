import 'package:latlong2/latlong.dart';

class SearchDestinationResult {
  final bool cancel;
  final bool manual;
  final LatLng? position;
  final String? desninationName;
  final String? description;

  SearchDestinationResult({

    required this.cancel,
    required this.manual,
    this.position,
    this.desninationName,
    this.description
    
  });
}
