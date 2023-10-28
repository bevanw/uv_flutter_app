import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:uv_flutter_app/apis/niwa/models/skye_types.dart';

import '../../apis/niwa/models/uv_forecast.dart';
import '../../apis/niwa/models/uv_index.dart';
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
  SkyTypes skyTypeFilter = SkyTypes.clear;

  void updateClearSkySelected(bool clearSkySelected) {
    setState(() {
      clearSkySelected ? skyTypeFilter = SkyTypes.clear : null;
    });
  }

  void updateCloudySkySelected(bool cloudySkySelected) {
    setState(() {
      cloudySkySelected ? skyTypeFilter = SkyTypes.cloudy : null;
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
    return Padding(
      padding: const EdgeInsets.only(
        left: 60,
        right: 90,
        bottom: 40,
        top: 70,
      ),
      child: Column(
        children: [
          Expanded(
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 24,
                minY: 0,
                maxY: UVIndex.maxIndex.toDouble(),
                titlesData: const FlTitlesData(
                  rightTitles: AxisTitles(
                    axisNameSize: 20,
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    axisNameSize: 20,
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: const FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                lineBarsData: [
                  if (skyTypeFilter == SkyTypes.clear)
                    LineChartBarData(
                        spots: getChartSpots(widget.clearSkyData),
                        isCurved: true,
                        dotData: const FlDotData(show: false),
                        barWidth: 4,
                        color: Colors.blue,
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.blue.withOpacity(0.3),
                        )),
                  if (skyTypeFilter == SkyTypes.cloudy)
                    LineChartBarData(
                        spots: getChartSpots(widget.cloudySkyData),
                        isCurved: true,
                        dotData: const FlDotData(show: false),
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
          const SizedBox(
            height: 20,
          ),
          Wrap(
            spacing: 10,
            children: [
              FilterChip(
                label: const Text('Clear Sky'),
                selected: skyTypeFilter == SkyTypes.clear,
                onSelected: updateClearSkySelected,
              ),
              FilterChip(
                label: const Text('Cloudy Sky'),
                selected: skyTypeFilter == SkyTypes.cloudy,
                onSelected: updateCloudySkySelected,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
