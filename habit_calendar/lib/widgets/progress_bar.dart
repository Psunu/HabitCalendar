import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProgressBar extends StatelessWidget {
  final _borderRadius = BorderRadius.circular(10.0);

  final double percentage;
  final double duration;
  final BoxConstraints constraints;

  ProgressBar({this.percentage, this.duration, this.constraints});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: _borderRadius,
          ),
        ),
        AnimatedContainer(
          width: constraints.maxWidth * percentage,
          height: constraints.maxHeight,
          decoration: BoxDecoration(
            color: context.theme.primaryColor,
            borderRadius: _borderRadius,
          ),
          duration: duration ??
              const Duration(
                milliseconds: 200,
              ),
        ),
      ],
    );
  }
}
