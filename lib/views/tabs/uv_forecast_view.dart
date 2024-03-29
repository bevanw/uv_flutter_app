import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../apis/niwa/models/skye_types.dart';
import '../../apis/niwa/models/uv_index.dart';
import '../../constants/colors.dart';
import '../../providers/api_providers.dart';
import '../../widgets/selection_chip.dart';

class UVForecastTab extends ConsumerStatefulWidget {
  final UVParameters uvParameters;
  const UVForecastTab({super.key, required this.uvParameters});

  @override
  ConsumerState<UVForecastTab> createState() => _UVForecastTab();
}

class _UVForecastTab extends ConsumerState<UVForecastTab> {
  @override
  Widget build(BuildContext context) {
    final uvForecastAsyncValue = ref.watch(uvForecastProvider(widget.uvParameters));

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
    super.key,
    required this.clearSkyData,
    required this.cloudySkyData,
  });

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
      final uvIndex = entry.value;
      return FlSpot(uvIndex.time.hour.toDouble(), uvIndex.index.toDouble());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 40,
        right: 50,
        bottom: 40,
        top: 40,
      ),
      child: Column(
        children: [
          Expanded(
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: UVIndex.maxIndex.toDouble(),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 3,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      getTitlesWidget: (value, meta) {
                        return Text("${value.toInt()}:00");
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 3,
                  drawHorizontalLine: true,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: AppColors.gridLines,
                      strokeWidth: 2,
                    );
                  },
                ),
                borderData: FlBorderData(
                  show: true,
                  border: const Border.symmetric(horizontal: BorderSide(color: AppColors.gridLines, width: 2)),
                ),
                lineBarsData: [
                  if (skyTypeFilter == SkyTypes.clear)
                    LineChartBarData(
                        spots: getChartSpots(widget.clearSkyData),
                        isCurved: true,
                        dotData: const FlDotData(show: false),
                        barWidth: 4,
                        color: AppColors.dark,
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.dark.withOpacity(0.3),
                        )),
                  if (skyTypeFilter == SkyTypes.cloudy)
                    LineChartBarData(
                        spots: getChartSpots(widget.cloudySkyData),
                        isCurved: true,
                        dotData: const FlDotData(show: false),
                        barWidth: 4,
                        color: AppColors.light,
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.light.withOpacity(0.3),
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
              SelectionChip(
                label: const Text('Clear Sky'),
                selected: skyTypeFilter == SkyTypes.clear,
                onSelected: updateClearSkySelected,
              ),
              SelectionChip(
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
