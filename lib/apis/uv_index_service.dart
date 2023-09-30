import 'package:http/http.dart' as http;
import 'package:uv_flutter_app/extensions/http_response.dart';
import 'package:xml/xml.dart';

import 'models/uv_index.dart';

/// Retrieves the current UV Index for sunny/cloudy days using [latitude], [longitude] postioning and [skyType].
///
/// Reference:
/// https://developer.niwa.co.nz/docs/uv-api/1/routes/current.svg/get
Future<UVIndex> fetchUVIndex(
    double latitude, double longitude, SkyTypes skyType) async {
  final response = await http.get(
    Uri.parse(
        'https://api.niwa.co.nz/uv/current.svg?lat=$latitude&long=$longitude&sky=$skyType'),
    headers: {
      'x-apikey': const String.fromEnvironment('NIWA_API_KEY'),
    },
  );

  if (response.success) {
    return UVIndex.fromWSvgXml(XmlDocument.parse(response.body));
  } else {
    throw Exception(
        'Status: ${response.statusCode} Body: ${response.body.toString()}');
  }
}

enum SkyTypes {
  cloudy,
  clear,
}
