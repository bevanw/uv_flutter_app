import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../apis/niwa/niwa_api_service.dart';

final httpClientProvider = Provider<http.Client>((ref) => http.Client());

final niwaApiServiceProvider = Provider<NiwaApiService>((ref) {
  final httpClient = ref.read(httpClientProvider);
  const apiKey = String.fromEnvironment('NIWA_API_KEY');
  return NiwaApiService(httpClient, apiKey);
});
