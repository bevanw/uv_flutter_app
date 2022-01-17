import 'dart:convert';

import 'package:http/http.dart' as http;

/// Retrieves UV Index forecast for sunny/cloudy days using [latitude] and [longitude] postioning.
///
/// Reference:
/// https://developer.niwa.co.nz/docs/uv-api/1/routes/data/get
Future<UVForecast> fetchUVForecast(double latitude, double longitude) async {
  final response = await http.get(
    Uri.parse('https://api.niwa.co.nz/uv/data?lat=$latitude&long=$longitude'),
    headers: {
      'x-apikey': 'MJiVkz4dsl35BkeXbpGdTZGgq6vywsGp',
    },
  );

  if (response.statusCode == 200) {
    return UVForecast.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Status: ${response.statusCode} Body: ${response.body.toString()}');
  }
}

class UVForecast {
  final List<UVIndex> clearSky;
  final List<UVIndex> cloudySky;

  UVForecast({
    required this.clearSky,
    required this.cloudySky,
  });

  /// JSON Structure
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
  /// Helpful reference: https://www.bezkoder.com/dart-flutter-parse-json-string-array-to-object-list/
  factory UVForecast.fromJson(dynamic json) {
    return UVForecast(
      clearSky: ((json['products'] as Iterable).firstWhere((element) => element['name'] == 'clear_sky_uv_index')['values'] as Iterable)
          .map((indexJson) => UVIndex.fromJson(indexJson))
          .toList(),
      cloudySky: ((json['products'] as Iterable).firstWhere((element) => element['name'] == 'cloudy_sky_uv_index')['values'] as Iterable)
          .map((indexJson) => UVIndex.fromJson(indexJson))
          .toList(),
    );
  }
}

class UVIndex {
  final DateTime time;
  final num value;

  UVIndex({
    required this.time,
    required this.value,
  });

  factory UVIndex.fromJson(Map<String, dynamic> json) {
    return UVIndex(
      time: DateTime.parse(json['time'].toString()),
      value: json['value'],
    );
  }
}
