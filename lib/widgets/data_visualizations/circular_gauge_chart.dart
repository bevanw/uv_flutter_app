import 'dart:math';

import 'package:flutter/material.dart';

import '../../constants/type_scale.dart';

class CircularGaugeChart extends StatelessWidget {
  /// The progress between 0 and 1.
  final double progress;

  /// The main progress gauge colour.
  final Color progressColor;

  /// The background colour - with automatic opacity applied.
  final Color progressBackgroundColor;

  /// The icon that lives in the center of the gauge.
  final IconData icon;

  /// The title that lives under the gauge.
  final String gaugeTitle;

  /// The subtitle that lives under the title.
  final String gaugeSubtitleText;

  /// The maximum length of the progress bar,
  final double progressMaxLength;

  /// The width of the gauge progress bar.
  final double strokeWidth;

  const CircularGaugeChart({
    super.key,
    required this.progress,
    required this.progressColor,
    required this.progressBackgroundColor,
    required this.icon,
    required this.gaugeTitle,
    required this.gaugeSubtitleText,
    this.progressMaxLength = 0.8,
    this.strokeWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Padding in relation to the text below the progress indicator.
        // This will center the entire widget.
        const Padding(padding: EdgeInsets.only(top: 60)),
        Transform.scale(
          scale: 4,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Transform.rotate(
                angle: -progressMaxLength * pi,
                child: CustomPaint(
                  painter: ArcGaugePainter(
                    backgroundColor: progressBackgroundColor.withOpacity(0.2),
                    progressMaxLength: progressMaxLength,
                    strokeWidth: strokeWidth,
                  ),
                  child: CircularProgressIndicator(
                    strokeWidth: strokeWidth,
                    color: progressColor,
                    strokeCap: StrokeCap.round,
                    value: progress.clamp(0.0, progressMaxLength),
                  ),
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
        const SizedBox(height: 40),
        Text(
          gaugeTitle,
          style: TypeScale.h4.copyWith(fontWeight: FontWeight.normal),
        ),
        Text(
          gaugeSubtitleText,
          style: TypeScale.caption,
        ),
      ],
    );
  }
}

class ArcGaugePainter extends CustomPainter {
  final Color backgroundColor;
  final double progressMaxLength;
  final double strokeWidth;

  ArcGaugePainter({
    required this.backgroundColor,
    required this.progressMaxLength,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Define a rectangle that represents the area to be drawn.
    Rect rect = Rect.fromPoints(const Offset(0, 0), Offset(size.width, size.height));

    // Calculate the sweep angle based on the progress length.
    double sweepAngle = (360 * progressMaxLength) * pi / 180;

    // Draw a curved line with rounded ends from 8am to 4pm.
    canvas.drawArc(rect, -pi / 2, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
