import 'package:dio/dio.dart';

class PlacesInterceptor extends Interceptor {
  final accessToken =
      'pk.eyJ1IjoiZWxpYXNkaWF6MTAwNSIsImEiOiJja3o4c3Nla20xbnBrMnBwMTN4cXpuOGYxIn0.wfniiVLrGVbimAqr_OKyMg';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters
        .addAll({'access_token': accessToken, 'language': 'es', 'limit': 7});

    super.onRequest(options, handler);
  }
}
