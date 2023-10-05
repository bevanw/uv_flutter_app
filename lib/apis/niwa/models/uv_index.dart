import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

class UVIndex {
  final DateTime time;
  final num value;

  UVIndex({
    required this.time,
    required this.value,
  });

  /// Unfortunately there is no NIWA that returns the current UV Index in an exchange language like JSN or XML.
  /// Instead, the closest we can get is an SVG. We really don't want to have to display an SVG either.
  /// If we rely on interrogating the SVG, we risk NIWA changing it. But we don't have a lot of options at this stage.
  /// This parses the [svgXml] response and rips that fucker out from within:
  /// {@tool snippet}
  /// ```xml
  /// <svg xmlns="http://www.w3.org/2000/svg" width="400" height="600">
  ///	 <text y="220">
  ///	 	<tspan class="value">7 at Jan 17th 4:30 pm</tspan>
  ///	 </text>
  /// </svg>
  /// ```
  /// {@end-tool}
  factory UVIndex.fromWSvgXml(XmlDocument svgXml) {
    final uvValue = svgXml.xpath('/svg/text[@y="220"]/tspan[@class="value"]');
    final uvIndex = uvValue.first.innerText.split(' ')[0];
    return UVIndex(time: DateTime.now(), value: num.parse(uvIndex));
  }
}
