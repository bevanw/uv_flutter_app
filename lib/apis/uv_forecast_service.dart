import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uv_flutter_app/extensions/http_response.dart';

import 'models/uv_forecast.dart';

/// Retrieves UV Index forecast for sunny/cloudy days using [latitude] and [longitude] postioning.
///
/// Response Structure
/// {@tool snippet}
/// ```dart
/// {
///   "products": [
///     {
///       "values": [
///         {
///           "time": "2022-01-16T00:00:00.000Z",
///           "value": 12.2892
///         }
///       ],
///       "name": "clear_sky_uv_index"
///     },
///     {
///       "values": [
///         {
///           "time": "2022-01-16T00:00:00.000Z",
///           "value": 11.2901
///         }
///       ],
///       "name": "cloudy_sky_uv_index"
///     }
///   ],
///   "coord": "EPSG:4326,-39.0,174.0"
/// }
/// ```
/// {@end-tool}
///
/// JSON reference:
/// https://www.bezkoder.com/dart-flutter-parse-json-string-array-to-object-list/
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
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    return UVForecast(
      clearSky: _fetchUVListFromJson(decodedResponse, 'clear_sky_uv_index'),
      cloudySky: _fetchUVListFromJson(decodedResponse, 'cloudy_sky_uv_index'),
    );
  } else {
    throw Exception(
        'Status: ${response.statusCode} Body: ${response.body.toString()}');
  }
}

List<UVIndex> _fetchUVListFromJson(Map json, String nameFilter) {
  return ((json['products'] as Iterable)
              .firstWhere((element) => element['name'] == nameFilter)['values']
          as Iterable)
      .map((indexJson) => UVIndex(
            time: DateTime.parse(indexJson['time'].toString()),
            value: indexJson['value'],
          ))
      .toList();
}
