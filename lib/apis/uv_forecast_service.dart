import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uv_flutter_app/extensions/http_response.dart';

import 'models/uv_forecast.dart';

/// Retrieves UV Index forecast for sunny/cloudy days using [latitude] and [longitude] postioning.
///
/// API Reference:
/// https://developer.niwa.co.nz/docs/uv-api/1/routes/data/get
Future<UVForecast> fetchUVForecast(double latitude, double longitude) async {
  final response = await http.get(
    Uri.parse('https://api.niwa.co.nz/uv/data?lat=$latitude&long=$longitude'),
    headers: {
      'x-apikey': const String.fromEnvironment('NIWA_API_KEY'),
    },
  );

  if (response.success) {
    return UVForecast.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(
        'Status: ${response.statusCode} Body: ${response.body.toString()}');
  }
}
