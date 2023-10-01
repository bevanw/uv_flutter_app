import 'package:http/http.dart' as http;
import 'package:riverpod/riverpod.dart';

import '../apis/niwa/niwa_api_service.dart';

final httpClientProvider = Provider<http.Client>((ref) => http.Client());

final niwaApiServiceProvider = Provider<NiwaApiService>((ref) {
  final httpClient = ref.read(httpClientProvider);
  return NiwaApiService(httpClient);
});
