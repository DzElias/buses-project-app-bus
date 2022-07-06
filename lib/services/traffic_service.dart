import 'package:user_app/services/places_interceptor.dart';
import 'package:dio/dio.dart';

import '../commons/models/places_response.dart';
import 'package:latlong2/latlong.dart';

class TrafficService {
  final Dio _dioPlaces;
  final String _basePlacesUrl = 'https://api.mapbox.com/geocoding/v5/mapbox.places';

  TrafficService() : _dioPlaces = Dio()..interceptors.add(PlacesInterceptor());

  Future<List<Feature>> getResultsByQuery(
      LatLng proximity, String query) async {
    if (query.isEmpty) return [];

    final url = '$_basePlacesUrl/$query.json';

    final resp = await _dioPlaces.get(url, queryParameters: {
      'proximity': '${proximity.longitude},${proximity.latitude}',
      'country': 'PY',
      'limit': '3'
    });

    final placesResponse = PlacesResponse.fromJson(resp.data);

    return placesResponse.features;
  }
}
