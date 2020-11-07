import 'package:flutter/material.dart';
import 'package:habit_calendar/constants/constants.dart';

class Alert extends StatefulWidget {
  Alert({
    Key key,
    @required this.child,
    @required this.alertContent,
    this.isAlertOn = false,
    this.duration = const Duration(milliseconds: Constants.smallAnimationSpeed),
    this.curve = Curves.ease,
    this.marginChildTop = 5.0,
  })  : assert(child != null),
        assert(alertContent != null),
        super(key: key);

  final Widget child;
  final Widget alertContent;
  final bool isAlertOn;
  final Duration duration;
  final Curve curve;
  final double marginChildTop;

  @override
  _AlertState createState() => _AlertState();
}

class _AlertState extends State<Alert> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = _animationController.drive(
      Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: widget.curve)),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isAlertOn) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    return Column(
      children: [
        FadeTransition(
          opacity: _animation,
          child: SizeTransition(
            sizeFactor: _animation,
            child: widget.alertContent,
          ),
        ),
        SizedBox(
          height: widget.marginChildTop,
        ),
        widget.child,
      ],
    );
  }
}
