import 'dart:math';

import 'package:flutter/material.dart';

import '../../constants/type_scale.dart';

class CircularGaugeChart extends StatelessWidget {
  final double progress;
  final Color progressColor;
  final Color progressBackgroundColor;
  final IconData icon;
  final String gaugeText;
  final String gaugeSubtitleText;

  const CircularGaugeChart({
    super.key,
    required this.progress,
    required this.progressColor,
    required this.progressBackgroundColor,
    required this.icon,
    required this.gaugeText,
    required this.gaugeSubtitleText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Padding in relation to the text below the progress indicator.
        const Padding(padding: EdgeInsets.only(top: 60)),
        Transform.scale(
          scale: 4,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Transform.rotate(
                angle: -0.8 * pi, // Progress from 8 o'clock to 4 o'clock
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: progressColor,
                  backgroundColor: progressBackgroundColor.withOpacity(0.2),
                  strokeCap: StrokeCap.round,
                  value: progress.clamp(0.0, 0.8),
                ),
              ),
              Icon(
                icon,
                size: 20,
                color: progressColor,
              ),
            ],
          ),
        ),
        const SizedBox(height: 60),
        Text(
          gaugeText,
          style: TypeScale.h4,
        ),
        Text(
          gaugeSubtitleText,
          style: TypeScale.caption,
        ),
      ],
    );
  }
}
