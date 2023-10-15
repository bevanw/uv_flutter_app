import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../apis/niwa/models/uv_index.dart';
import '../../providers/api_providers.dart';
import '../../widgets/data_visualizations/circular_gauge_chart.dart';

class UVIndexTab extends ConsumerStatefulWidget {
  const UVIndexTab({Key? key}) : super(key: key);

  @override
  ConsumerState<UVIndexTab> createState() => _UVIndexTab();
}

class _UVIndexTab extends ConsumerState<UVIndexTab> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<UVIndex> uvIndexAsyncValue = ref.watch(uvIndexProvider);

    return uvIndexAsyncValue.when(
      data: (uvIndex) {
        return Transform.scale(
          scale: 1.5,
          child: CircularGaugeChart(
            progress: uvIndex.index / UVIndex.maxIndex * 0.8,
            progressColor: uvIndex.getUvColour(),
            progressBackgroundColor: uvIndex.getUvColour(),
            icon: Icons.sunny,
            gaugeText: uvIndex.index.toString(),
            gaugeSubtitleText: "UV Index",
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Error: $error'),
    );
  }
}
