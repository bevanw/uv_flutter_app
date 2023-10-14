import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uv_flutter_app/extensions/http_response_extensions.dart';
import 'package:xml/xml.dart';

import 'models/skye_types.dart';
import 'models/uv_forecast.dart';
import 'models/uv_index.dart';

class NiwaApiService {
  final http.Client _httpClient;
  final String _apiKey;

  NiwaApiService(this._httpClient, this._apiKey);

  /// Retrieves UV Index forecast for sunny/cloudy days using [latitude] and [longitude] postioning.
  ///
  /// API Reference:
  /// https://developer.niwa.co.nz/docs/uv-api/1/routes/data/get
  Future<UVForecast> fetchUVForecast(double latitude, double longitude) async {
    final response = await _httpClient.get(
      Uri.parse('https://api.niwa.co.nz/uv/data?lat=$latitude&long=$longitude'),
      headers: {
        'x-apikey': _apiKey,
      },
    );

    if (response.success) {
      return UVForecast.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Status: ${response.statusCode} Body: ${response.body.toString()}');
    }
  }

  /// Retrieves the current UV Index for sunny/cloudy days using [latitude], [longitude] postioning and [skyType].
  ///
  /// Reference:
  /// https://developer.niwa.co.nz/docs/uv-api/1/routes/current.svg/get
  Future<UVIndex> fetchUVIndex(double latitude, double longitude, SkyTypes skyType) async {
    final response = await _httpClient.get(
      Uri.parse('https://api.niwa.co.nz/uv/current.svg?lat=$latitude&long=$longitude&sky=$skyType'),
      headers: {
        'x-apikey': _apiKey,
      },
    );

    if (response.success) {
      return UVIndex.fromWSvgXml(XmlDocument.parse(response.body));
    } else {
      throw Exception('Status: ${response.statusCode} Body: ${response.body.toString()}');
    }
  }
}
