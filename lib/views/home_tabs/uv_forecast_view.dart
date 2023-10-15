import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uv_flutter_app/apis/niwa/models/skye_types.dart';

import '../../apis/niwa/models/uv_forecast.dart';
import '../../apis/niwa/models/uv_index.dart';
import '../../providers/api_providers.dart';

class UVForecastTab extends ConsumerStatefulWidget {
  const UVForecastTab({Key? key}) : super(key: key);

  @override
  ConsumerState<UVForecastTab> createState() => _UVForecastTab();
}

class _UVForecastTab extends ConsumerState<UVForecastTab> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<UVForecast> uvForecastAsyncValue = ref.watch(uvForecastProvider(NiwaApiServiceParameters(latitude: -35, longitude: 175, skyTypes: SkyTypes.clear)));

    return uvForecastAsyncValue.when(
      data: (uvForecast) {
        return UVForecastChart.fromUVData(uvForecast);
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Error: $error'),
    );
  }
}

class UVForecastChart extends StatelessWidget {
  final List<charts.Series<UVIndex, DateTime>> seriesList;

  const UVForecastChart(this.seriesList, {Key? key}) : super(key: key);

  /// Creates a [UVForecastChart] with UV data.
  factory UVForecastChart.fromUVData(UVForecast forecast) {
    var todaysForecast = forecast.fetchForecastByDay(DateTime.now());
    return UVForecastChart([
      charts.Series<UVIndex, DateTime>(
        id: 'ClearSkyData',
        displayName: 'Clear Skies UV Index',
        domainFn: (UVIndex index, _) => index.time,
        measureFn: (UVIndex index, _) => index.index,
        data: todaysForecast.clearSky,
      ),
      charts.Series<UVIndex, DateTime>(
        id: 'CloudySkyData',
        displayName: 'Cloudy Skies UV Index',
        domainFn: (UVIndex index, _) => index.time,
        measureFn: (UVIndex index, _) => index.index,
        data: todaysForecast.cloudySky,
      )
    ]);
  }

  static charts.Color fromDartColor(Color color) {
    return charts.Color(r: color.red, g: color.green, b: color.blue, a: color.withOpacity(0.1).alpha);
  }

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(seriesList,
        // Allow enough space in the left and right chart margins for the annotations.
        layoutConfig: charts.LayoutConfig(leftMarginSpec: charts.MarginSpec.fixedPixel(80), topMarginSpec: charts.MarginSpec.fixedPixel(40), rightMarginSpec: charts.MarginSpec.fixedPixel(80), bottomMarginSpec: charts.MarginSpec.fixedPixel(40)),
        behaviors: [
          // Define one domain and two measure annotations configured to render labels in the chart margins.
          charts.RangeAnnotation([
            charts.RangeAnnotationSegment(0, 3, charts.RangeAnnotationAxisType.measure, middleLabel: 'Low', color: fromDartColor(UVIndex.low)),
            charts.RangeAnnotationSegment(3, 6, charts.RangeAnnotationAxisType.measure, middleLabel: 'Moderate', color: fromDartColor(UVIndex.moderate)),
            charts.RangeAnnotationSegment(6, 8, charts.RangeAnnotationAxisType.measure, middleLabel: 'High', color: fromDartColor(UVIndex.high)),
            charts.RangeAnnotationSegment(8, 11, charts.RangeAnnotationAxisType.measure, middleLabel: 'Very High', color: fromDartColor(UVIndex.veryHigh)),
            charts.RangeAnnotationSegment(11, 14, charts.RangeAnnotationAxisType.measure, middleLabel: 'Extreme', color: fromDartColor(UVIndex.extreme)),
          ], defaultLabelPosition: charts.AnnotationLabelPosition.margin),
        ]);
  }
}
