import 'package:bustracking/commons/models/search_response.dart';
import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

class TrafficService {
  //singleton
  TrafficService._privateConstructor();
  static final TrafficService _instance = TrafficService._privateConstructor();
  factory TrafficService() {
    return _instance;
  }

  final _dio = Dio();
  final _baseUrl = 'https://api.mapbox.com/geocoding/v5';
  final _apiKey =
      'pk.eyJ1IjoiZWxpYXNkaWF6MTAwNSIsImEiOiJja3d4eDQ3OTcwaHk3Mm51cjNmcWRvZjA2In0.AAF794oxyxFR_-wAvVwMfQ';

  Future<SearchResponse> getQueryResults(
      String search, LatLng proximity) async {
    final url = '$_baseUrl/mapbox.places/$search.json';
    try {
      final resp = await _dio.get(url, queryParameters: {
        'access_token': _apiKey,
        'autocomplete': 'true',
        'proximity': '${proximity.longitude},${proximity.latitude}',
        'language': 'es',
      });
      final searchResponse = searchResponseFromJson(resp.data);
      return searchResponse;
    } catch (e) {
      return SearchResponse(type: '', attribution: '', features: [], query: []);
    }
  }
}
