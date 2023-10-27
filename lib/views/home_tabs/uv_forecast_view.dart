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
        var todaysForecast = uvForecast.fetchForecastByDay(DateTime.now());
        return UVForecastChart(
          clearSkyData: todaysForecast.clearSky,
          cloudySkyData: todaysForecast.cloudySky,
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Error: $error'),
    );
  }
}

class UVForecastChart extends StatefulWidget {
  final List<UVIndex> clearSkyData;
  final List<UVIndex> cloudySkyData;

  const UVForecastChart({
    Key? key,
    required this.clearSkyData,
    required this.cloudySkyData,
  }) : super(key: key);

  @override
  State<UVForecastChart> createState() => _UVForecastChartState();
}

class _UVForecastChartState extends State<UVForecastChart> {
  bool clearSkySelected = true;
  bool cloudySkySelected = false;

  void updateClearSkySelected(bool clearSkySelected) {
    setState(() {
      this.clearSkySelected = clearSkySelected;
    });
  }

  void updateCloudySkySelected(bool cloudySkySelected) {
    setState(() {
      this.cloudySkySelected = cloudySkySelected;
    });
  }

  List<FlSpot> getChartSpots(List<UVIndex> data) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final uvIndex = entry.value;
      return FlSpot(index.toDouble(), uvIndex.index.toDouble());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 40,
            right: 90,
          ),
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: 24,
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
                if (clearSkySelected)
                  LineChartBarData(
                      spots: getChartSpots(widget.clearSkyData),
                      isCurved: true,
                      barWidth: 4,
                      color: Colors.blue,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.withOpacity(0.3),
                      )),
                if (cloudySkySelected)
                  LineChartBarData(
                      spots: getChartSpots(widget.cloudySkyData),
                      isCurved: true,
                      barWidth: 4,
                      color: Colors.grey,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.grey.withOpacity(0.3),
                      )),
              ],
            ),
          ),
        ),
        Wrap(
          spacing: 10,
          children: [
            FilterChip(
              label: const Text('Clear Sky'),
              selected: clearSkySelected,
              onSelected: updateClearSkySelected,
            ),
            FilterChip(
              label: const Text('Cloudy Sky'),
              selected: cloudySkySelected,
              onSelected: updateCloudySkySelected,
            ),
          ],
        ),
      ],
    );
  }
}
