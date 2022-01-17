import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:uv_flutter_app/apis/uv_index.dart';
import 'package:xml/xml.dart';

/// Retrieves the current UV Index for sunny/cloudy days using [latitude], [longitude] postioning and the [skyType].
///
/// Reference:
/// https://developer.niwa.co.nz/docs/uv-api/1/routes/current.svg/get
Future<UVIndex> fetchUVIndex(
    double latitude, double longitude, SkyTypes skyType) async {
  final response = await http.get(
    Uri.parse(
        'https://api.niwa.co.nz/uv/current.svg?lat=$latitude&long=$longitude&sky=$skyType'),
    headers: {
      'x-apikey': dotenv.get('NIWA_API_KEY'),
    },
  );

  if (response.statusCode == 200) {
    // Unfortunately there is no NIWA that returns the current UV Index in an exchange language like JSN or XML.
    // Instead, the closest we can get is an SVG. We really don't want to have to display an SVG either.
    // If we rely on interrogating the SVG, we risk NIWA changing it. But we don't have a lot of options at this stage.
    // SVG part we're interested in:
    // ```
    /// <svg xmlns="http://www.w3.org/2000/svg" width="400" height="600">
    ///	 <text y="220">
    ///	 	<tspan class="value">7 at Jan 17th 4:30 pm</tspan>
    ///	 </text>
    /// </svg>
    // ```
    final svgDocument = XmlDocument.parse(response.body);
    final uvIndex = svgDocument
        .findAllElements('text')
        .firstWhere((element) => element.getAttribute('y') == '220')
        .childElements
        .firstWhere((element) => element.getAttribute('class') == 'value')
        .text
        .split(' ')[0];
    return UVIndex(time: DateTime.now(), value: num.parse(uvIndex));
  } else {
    throw Exception(
        'Status: ${response.statusCode} Body: ${response.body.toString()}');
  }
}

enum SkyTypes {
  cloudy,
  clear,
}
