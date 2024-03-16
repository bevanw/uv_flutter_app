import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:uv_flutter_app/apis/niwa/models/uv_forecast.dart';

import '../apis/niwa/models/skye_types.dart';
import '../apis/niwa/models/uv_index.dart';
import '../apis/niwa/niwa_api_service.dart';

class UVParameters {
  final double latitude;
  final double longitude;
  final SkyTypes skyTypes;

  UVParameters({
    required this.latitude,
    required this.longitude,
    this.skyTypes = SkyTypes.clear,
  });
}

final httpClientProvider = Provider<http.Client>((ref) => http.Client());

final niwaApiServiceProvider = Provider<NiwaApiService>((ref) {
  final httpClient = ref.read(httpClientProvider);
  const apiKey = String.fromEnvironment('NIWA_API_KEY');
  return NiwaApiService(httpClient, apiKey);
});

final uvIndexProvider = FutureProvider.family<UVIndex, UVParameters>((ref, apiParameters) async {
  final niwaApiService = ref.read(niwaApiServiceProvider);
  return niwaApiService.fetchUVIndex(apiParameters.latitude, apiParameters.longitude, apiParameters.skyTypes);
});

final uvForecastProvider = FutureProvider.family<UVForecast, UVParameters>((ref, apiParameters) async {
  final niwaApiService = ref.read(niwaApiServiceProvider);
  return niwaApiService.fetchUVForecast(apiParameters.latitude, apiParameters.longitude);
});
