import 'uv_index.dart';

class UVForecast {
  final List<UVIndex> clearSky;
  final List<UVIndex> cloudySky;

  UVForecast({
    required this.clearSky,
    required this.cloudySky,
  });

  /// Maps the [response] in raw JSON to the [UVForecast]
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
  factory UVForecast.fromJson(dynamic response) {
    return UVForecast(
      clearSky: _fetchUVListFromJson(response, 'clear_sky_uv_index'),
      cloudySky: _fetchUVListFromJson(response, 'cloudy_sky_uv_index'),
    );
  }

  /// Fetches a [UVForecast] for a specifc date using a [date]
  UVForecast fetchForecastByDay(DateTime date) {
    // TODO: Brings back today and yestedays data??
    return UVForecast(
        clearSky:
            clearSky.where((index) => index.time.day == date.day).toList(),
        cloudySky:
            cloudySky.where((index) => index.time.day == date.day).toList());
  }

  static List<UVIndex> _fetchUVListFromJson(Map json, String nameFilter) {
    return ((json['products'] as Iterable).firstWhere(
            (element) => element['name'] == nameFilter)['values'] as Iterable)
        .map((indexJson) => UVIndex(
              time: DateTime.parse(indexJson['time'].toString()),
              value: indexJson['value'],
            ))
        .toList();
  }
}
