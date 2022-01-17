import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

/// Retrieves the current UV Index for sunny/cloudy days using [latitude], [longitude] postioning and the [skyType].
///
/// Reference:
/// https://developer.niwa.co.nz/docs/uv-api/1/routes/data/get
Future<SvgPicture> fetchUVIndexSvg(double latitude, double longitude, SkyTypes skyType) async {
  final response = await http.get(
    Uri.parse('https://api.niwa.co.nz/uv/current.svg?lat=$latitude&long=$longitude&sky=$skyType'),
    headers: {
      'x-apikey': dotenv.get('NIWA_API_KEY'),
    },
  );

  if (response.statusCode == 200) {
    // Unfortunately SvnPicture.string() does not support the following in the svg returned:
    // font-weight="bold"
    final svg = response.body.replaceAll(RegExp("font-weight=\"bold\"", caseSensitive: false), "font-weight=\"700\"");
    return SvgPicture.string(svg);
  } else {
    throw Exception('Status: ${response.statusCode} Body: ${response.body.toString()}');
  }
}

enum SkyTypes {
  cloudy,
  clear
}