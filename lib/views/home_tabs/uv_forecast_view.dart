import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../apis/niwa/models/uv_forecast.dart';
import '../../apis/niwa/models/uv_index.dart';
import '../../constants/type_scale.dart';
import '../../providers/api_providers.dart';

class UVForecastTab extends ConsumerStatefulWidget {
  final UVParameters uvParameters;
  const UVForecastTab({Key? key, required this.uvParameters}) : super(key: key);

  @override
  ConsumerState<UVForecastTab> createState() => _UVForecastTab();
}

class _UVForecastTab extends ConsumerState<UVForecastTab> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<UVForecast> uvForecastAsyncValue = ref.watch(uvForecastProvider(widget.uvParameters));

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
  final List<UVIndex> clearSkyData;
  final List<UVIndex> cloudySkyData;

  const UVForecastChart({super.key, required this.clearSkyData, required this.cloudySkyData});

  /// Creates a [UVForecastChart] with UV data.
  factory UVForecastChart.fromUVData(UVForecast forecast) {
    var todaysForecast = forecast.fetchForecastByDay(DateTime.now());
    return UVForecastChart(
      clearSkyData: todaysForecast.clearSky,
      cloudySkyData: todaysForecast.cloudySky,
    );
  }

  List<FlSpot> getChartSpots(List<UVIndex> data) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final uvIndex = entry.value;
      return FlSpot(index.toDouble(), uvIndex.index.toDouble());
    }).toList();
  }

  LinearGradient getGradient(List<UVIndex> data) {
    UVIndex dataMin = data.reduce((min, value) => value.index < min.index ? value : min);
    UVIndex dataMax = data.reduce((max, value) => value.index > max.index ? value : max);
    GradientData gradient = GradientData(stops: [
      3 / UVIndex.maxIndex.toDouble(),
      6 / UVIndex.maxIndex.toDouble(),
      8 / UVIndex.maxIndex.toDouble(),
      11 / UVIndex.maxIndex.toDouble(),
    ], colors: [
      UVIndex.low.withOpacity(0.5),
      UVIndex.moderate.withOpacity(0.5),
      UVIndex.high.withOpacity(0.5),
      UVIndex.extreme.withOpacity(0.5),
    ]);
    GradientData newGradient = gradient.getConstrainedGradient(
      dataYMin: dataMin.index.toDouble(),
      dataYMax: dataMax.index.toDouble(),
      graphYMin: 0,
      graphYMax: UVIndex.maxIndex.toDouble(),
    );

    return LinearGradient(
      begin: const Alignment(0, 1),
      end: const Alignment(0, -1),
      stops: newGradient.stops,
      colors: newGradient.colors,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 40,
        right: 90,
      ),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: clearSkyData.length.toDouble() - 1,
          minY: 0,
          maxY: UVIndex.maxIndex.toDouble(),
          titlesData: const FlTitlesData(
            bottomTitles: AxisTitles(
              axisNameSize: 60,
              axisNameWidget: Text("Time", style: TypeScale.h6),
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
              ),
            ),
            leftTitles: AxisTitles(
              axisNameSize: 60,
              axisNameWidget: Text("Intensity", style: TypeScale.h6),
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: getChartSpots(clearSkyData),
              isCurved: true,
              barWidth: 4,
              color: Colors.blue,
            ),
            LineChartBarData(
              spots: getChartSpots(cloudySkyData),
              isCurved: true,
              barWidth: 4,
              color: Colors.grey,
              belowBarData: BarAreaData(
                show: true,
                gradient: getGradient(cloudySkyData),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Linear interpolation: https://en.wikipedia.org/wiki/Linear_interpolation
double lerp(num a, num b, double t) {
  return a.toDouble() * (1.0 - t) + b.toDouble() * t;
}

/// Inverse lerp: https://www.gamedev.net/articles/programming/general-and-gameplay-programming/inverse-lerp-a-super-useful-yet-often-overlooked-function-r5230/
double invlerp(num a, num b, num x) {
  return (x - a.toDouble()) / (b.toDouble() - a.toDouble());
}

/// For interpolating between each [Color]
Color lerpColor(Color a, Color b, double t) {
  int lerpInt(int a, int b, double t) => lerp(a, b, t).round();
  return Color.fromARGB(
    lerpInt(a.alpha, b.alpha, t),
    lerpInt(a.red, b.red, t),
    lerpInt(a.green, b.green, t),
    lerpInt(a.blue, b.blue, t),
  );
}

class GradientData {
  final List<double> stops;
  final List<Color> colors;

  GradientData({required this.stops, required this.colors}) : assert(stops.length == colors.length);

  // Get the color value at any point in a gradient
  Color getColor(double t) {
    assert(stops.length == colors.length);
    if (t <= 0) return colors.first;
    if (t >= 1) return colors.last;

    for (int i = 0; i < stops.length - 1; i++) {
      final stop = stops[i];
      final nextStop = stops[i + 1];
      final color = colors[i];
      final nextColor = colors[i + 1];
      if (t >= stop && t < nextStop) {
        final lerpT = invlerp(stop, nextStop, t);
        return lerpColor(color, nextColor, lerpT);
      }
    }

    return colors.last;
  }

  /// Calculate a new gradient for a subset of this gradient using the graph Y points and data Y points.
  GradientData getConstrainedGradient({
    required double dataYMin,
    required double dataYMax,
    required double graphYMin,
    required double graphYMax,
  }) {
    // The "new" beginning and end stop positions for the gradient
    final tMin = invlerp(graphYMin, graphYMax, dataYMin);
    final tMax = invlerp(graphYMin, graphYMax, dataYMax);

    final newStops = <double>[];
    final newColors = <Color>[];

    newStops.add(0);
    newColors.add(getColor(tMin));

    for (var i = 0; i < stops.length; i++) {
      final stop = stops[i];
      final color = colors[i];
      if (stop <= tMin || stop >= tMax) continue;
      final stopT = invlerp(tMin, tMax, stop);
      newStops.add(stopT);
      newColors.add(color);
    }

    newStops.add(1);
    newColors.add(getColor(tMax));

    return GradientData(stops: newStops, colors: newColors);
  }
}
