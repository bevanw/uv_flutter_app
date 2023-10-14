import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uv_flutter_app/constants/type_scale.dart';

import '../../apis/niwa/models/uv_index.dart';
import '../../providers/api_providers.dart';

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
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Transform.rotate(
                    angle: -0.8 * pi, // Progress from 8 o'clock to 4 o'clock
                    child: CircularProgressIndicator(
                      strokeWidth: 15,
                      color: uvIndex.getUvColour(),
                      backgroundColor: uvIndex.getUvColour().withOpacity(0.2),
                      strokeCap: StrokeCap.round,
                      value: (uvIndex.index / UVIndex.maxIndex * 0.8).clamp(0.0, 0.8),
                    ),
                  ),
                ),
                Text(
                  uvIndex.index.toString(),
                  style: TypeScale.h1.copyWith(color: uvIndex.getUvColour()),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              "UV Index",
              style: TypeScale.h3,
            ),
          ],
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Error: $error'),
    );
  }
}
