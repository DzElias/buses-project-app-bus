import 'package:latlong2/latlong.dart';

class SearchDestinationResult {
  final bool cancel;
  final bool manual;
  final LatLng? position;
  final String? name;
  final String? description;

  SearchDestinationResult({
    required this.cancel,
    this.manual = false,
    this.position,
    this.name,
    this.description,
  });

  // Todo:
  // name, description, latlon

  @override
  String toString() {
    return '{ cancel: $cancel, manual: $manual }';
  }
}
