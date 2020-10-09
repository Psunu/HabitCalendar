import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SlidableController {
  SlidableController();

  void Function() reverse;
}

class Slidable extends StatefulWidget {
  Slidable({
    @required Key key,
    @required this.child,
    @required this.background,
    this.controller,
    this.onSlided,
    this.slideThresholds = 0.4,
    this.movementDuration = const Duration(milliseconds: 200),
    this.dragStartBehavior = DragStartBehavior.start,
  })  : assert(key != null),
        assert(background != null),
        super(key: key);

  final Widget child;
  final Widget background;
  final SlidableController controller;
  final VoidCallback onSlided;
  final double slideThresholds;
  final Duration movementDuration;
  final DragStartBehavior dragStartBehavior;

  @override
  _SlidableState createState() => _SlidableState();
}

class _SlidableState extends State<Slidable> with TickerProviderStateMixin {
  AnimationController _moveController;
  Animation<Offset> _moveAnimation;

  double _dragExtent = 0.0;
  bool _gotoStart = false;

  @override
  void initState() {
    super.initState();
    _moveController =
        AnimationController(duration: widget.movementDuration, vsync: this);
    _updateMoveAnimation();

    if (widget.controller != null) {
      widget.controller.reverse = () => _moveController.animateBack(
            0.0,
            duration: widget.movementDuration,
            curve: Curves.ease,
          );
    }
  }

  @override
  void dispose() {
    _moveController.dispose();
    super.dispose();
  }

  void _updateMoveAnimation() {
    final double end = _dragExtent.sign;

    _moveAnimation = _moveController.drive(
      Tween<Offset>(
        begin: Offset.zero,
        end: Offset(end, 0.0),
      ),
    );
  }

  void _handleDragStart(DragStartDetails details) {
    if (_moveController.isAnimating || _gotoStart) {
      _dragExtent =
          _moveController.value * Get.context.size.width * _dragExtent.sign;
      _moveController.stop();
      _gotoStart = false;
    } else {
      _dragExtent = 0;
      _moveController.value = 0;
    }
    setState(() {
      _updateMoveAnimation();
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_moveController.isAnimating) return;

    final double delta = details.primaryDelta;
    final double oldDragExtent = _dragExtent;

    switch (Directionality.of(context)) {
      case TextDirection.rtl:
        if (_dragExtent + delta > 0) _dragExtent += delta;
        break;
      case TextDirection.ltr:
        if (_dragExtent + delta < 0) _dragExtent += delta;
        break;
    }

    if (oldDragExtent.sign != _dragExtent.sign) {
      setState(() {
        _updateMoveAnimation();
      });
    }
    if (!_moveController.isAnimating) {
      _moveController.value = _dragExtent.abs() / Get.context.size.width;
    }
  }

  Future<void> _handleDragEnd(DragEndDetails details) async {
    if (_moveController.isAnimating) return;

    if (_moveController.value > widget.slideThresholds) {
      await _moveController.animateBack(
        widget.slideThresholds,
        duration: widget.movementDuration,
        curve: Curves.ease,
      );

      _gotoStart = true;
      if (widget.onSlided != null) widget.onSlided();
    } else
      _moveController.animateBack(
        0.0,
        duration: widget.movementDuration,
        curve: Curves.ease,
      );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = SlideTransition(
      position: _moveAnimation,
      child: widget.child,
    );

    if (widget.background != null) {
      content = Stack(children: <Widget>[
        Positioned.fill(
          child: widget.background,
        ),
        content,
      ]);
    }

    return GestureDetector(
      onHorizontalDragStart: _handleDragStart,
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      behavior: HitTestBehavior.opaque,
      child: content,
      dragStartBehavior: widget.dragStartBehavior,
    );
  }
}
