import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../apis/niwa/models/uv_index.dart';
import '../../providers/api_providers.dart';
import '../../widgets/data_visualizations/circular_gauge_chart.dart';

class UVIndexTab extends ConsumerStatefulWidget {
  final UVParameters uvParameters;
  const UVIndexTab({super.key, required this.uvParameters});

  @override
  ConsumerState<UVIndexTab> createState() => _UVIndexTab();
}

class _UVIndexTab extends ConsumerState<UVIndexTab> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<UVIndex> uvIndexAsyncValue = ref.watch(uvIndexProvider(widget.uvParameters));

    return uvIndexAsyncValue.when(
      data: (uvIndex) {
        return Transform.scale(
          scale: 1.5,
          child: CircularGaugeChart(
            progress: uvIndex.index / UVIndex.maxIndex,
            progressColor: uvIndex.getUvColour(),
            progressBackgroundColor: uvIndex.getUvColour(),
            icon: Icons.sunny,
            gaugeTitle: uvIndex.index.toString(),
            gaugeSubtitleText: "UV Index",
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Error: $error'),
    );
  }
}
