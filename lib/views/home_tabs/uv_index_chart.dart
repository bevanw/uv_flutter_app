import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import '../../apis/models/uv_forecast.dart';
import '../../apis/uv_forecast_service.dart';

class UVIndexChartTab extends StatefulWidget {
  const UVIndexChartTab({Key? key}) : super(key: key);

  @override
  State<UVIndexChartTab> createState() => _UVIndexChartTab();
}

class _UVIndexChartTab extends State<UVIndexChartTab> {
  late Future<UVForecast> futureForecast;

  @override
  void initState() {
    super.initState();
    futureForecast = fetchUVForecast(-37, 175);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UVForecast>(
      future: futureForecast,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return UVIndexChart.fromUVData(snapshot.data!);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}

class UVIndexChart extends StatelessWidget {
  final List<charts.Series<UVIndex, DateTime>> seriesList;

  const UVIndexChart(this.seriesList, {Key? key}) : super(key: key);

  /// Creates a [UVIndexChart] with UV data.
  factory UVIndexChart.fromUVData(UVForecast forecast) {
    return UVIndexChart([
      charts.Series<UVIndex, DateTime>(
        id: 'ClearSkyData',
        displayName: 'Clear Skies UV Index',
        seriesColor: charts.MaterialPalette.black,
        domainFn: (UVIndex index, _) => index.time,
        measureFn: (UVIndex index, _) => index.value,
        data: forecast.clearSky,
      ),
      charts.Series<UVIndex, DateTime>(
        id: 'CloudySkyData',
        displayName: 'Cloudy Skies UV Index',
        seriesColor: charts.MaterialPalette.black,
        domainFn: (UVIndex index, _) => index.time,
        measureFn: (UVIndex index, _) => index.value,
        data: forecast.cloudySky,
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(seriesList,

        // Allow enough space in the left and right chart margins for the
        // annotations.
        layoutConfig: charts.LayoutConfig(
            leftMarginSpec: charts.MarginSpec.fixedPixel(60),
            topMarginSpec: charts.MarginSpec.fixedPixel(20),
            rightMarginSpec: charts.MarginSpec.fixedPixel(60),
            bottomMarginSpec: charts.MarginSpec.fixedPixel(20)),
        behaviors: [
          // Define one domain and two measure annotations configured to render
          // labels in the chart margins.
          charts.RangeAnnotation([
            charts.RangeAnnotationSegment(
                0, 3, charts.RangeAnnotationAxisType.measure,
                middleLabel: 'Low',
                color: charts.MaterialPalette.green.shadeDefault.lighter),
            charts.RangeAnnotationSegment(
                3, 6, charts.RangeAnnotationAxisType.measure,
                middleLabel: 'Moderate',
                color: charts.MaterialPalette.yellow.shadeDefault.lighter),
            charts.RangeAnnotationSegment(
                6, 8, charts.RangeAnnotationAxisType.measure,
                middleLabel: 'High',
                color: charts.MaterialPalette.deepOrange.shadeDefault.lighter),
            charts.RangeAnnotationSegment(
                8, 11, charts.RangeAnnotationAxisType.measure,
                middleLabel: 'Very High',
                color: charts.MaterialPalette.red.shadeDefault.lighter),
            charts.RangeAnnotationSegment(
                11, 14, charts.RangeAnnotationAxisType.measure,
                middleLabel: 'Extreme',
                color: charts.MaterialPalette.purple.shadeDefault.lighter),
          ], defaultLabelPosition: charts.AnnotationLabelPosition.margin),
        ]);
  }
}
