import 'package:flutter/material.dart';
import 'package:uv_flutter_app/constants/colors.dart';
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

class UVIndex {
  final DateTime time;
  final num index;

  static final UVRange low = UVRange(color: AppColors.dark, min: minIndex, max: 3);
  static final UVRange moderate = UVRange(color: AppColors.darkMedium, min: 4, max: 6);
  static final UVRange high = UVRange(color: AppColors.middle, min: 7, max: 8);
  static final UVRange veryHigh = UVRange(color: AppColors.lightMedium, min: 9, max: 11);
  static final UVRange extreme = UVRange(color: AppColors.light, min: 12, max: maxIndex);

  static const num minIndex = 0;
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
    if (index < low.max) {
      return low.color;
    } else if (index < moderate.max) {
      return moderate.color;
    } else if (index < high.max) {
      return high.color;
    } else if (index < veryHigh.max) {
      return veryHigh.color;
    } else {
      return extreme.color;
    }
  }
}

class UVRange {
  final Color color;
  final num min;
  final num max;

  UVRange({
    required this.color,
    required this.min,
    required this.max,
  });
}
