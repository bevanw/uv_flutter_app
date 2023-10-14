import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

class UVIndex {
  final DateTime time;
  final num index;

  static const Color low = Colors.green;
  static const Color moderate = Colors.yellow;
  static const Color high = Colors.orange;
  static const Color veryHigh = Colors.red;
  static const Color extreme = Colors.purple;

  static const num maxIndex = 14;

  UVIndex({
    required this.time,
    required this.index,
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
    return UVIndex(time: DateTime.now(), index: num.parse(uvIndex));
  }

  /// Returns the [Color] associated with the current index.
  Color getUvColour() {
    switch (index) {
      case 0:
      case 1:
      case 2:
      case 3:
        return UVIndex.low;
      case 4:
      case 5:
      case 6:
        return UVIndex.moderate;
      case 7:
      case 8:
        return UVIndex.high;
      case 9:
      case 10:
      case 11:
        return UVIndex.veryHigh;
      default:
        return UVIndex.extreme;
    }
  }
}
