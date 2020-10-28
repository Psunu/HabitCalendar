import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Reorderable<T> extends StatefulWidget {
  Reorderable({
    Key key,
    @required this.child,
    this.enabled = false,
    this.data,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.ease,
  })  : assert(child != null),
        super(key: key);

  final Widget child;

  // enabled : ReorderableItem
  // not enabled : ReorderableTarget
  final bool enabled;

  final T data;

  final Duration duration;

  final Curve curve;

  @override
  _ReorderableState<T> createState() => _ReorderableState<T>();
}

class _ReorderableState<T> extends State<Reorderable<T>> {
  @override
  Widget build(BuildContext context) {
    RenderBox box = context.findRenderObject() as RenderBox;

    Widget content;

    if (widget.enabled) {
      content = ReorderableItem<T>(data: widget.data, child: widget.child);
    } else {
      final Widget spacing = SizedBox(
        width: box?.size?.width ?? 100.0,
        height: box?.size?.height ?? 100.0,
      );
      content = ReorderableTarget<T>(child: widget.child);
    }

    return content;
  }
}

enum _DragEndKind { dropped, canceled }
typedef _OnDragEnd = void Function(
    Velocity velocity, Offset offset, bool wasAccepted);

// It is work for only vertical
class ReorderableItem<T> extends StatefulWidget {
  ReorderableItem({
    Key key,
    @required this.child,
    this.data,
    Offset initialPosition,
    this.onDragEnd,
  })  : assert(child != null),
        super(key: key);

  final Widget child;

  final T data;

  final _OnDragEnd onDragEnd;

  @override
  _ReorderableItemState<T> createState() => _ReorderableItemState<T>();
}

class _ReorderableItemState<T> extends State<ReorderableItem<T>>
    with TickerProviderStateMixin {
  _ReorderableTargetState<T> _activeTarget;
  final List<_ReorderableTargetState<T>> _enteredTargets =
      <_ReorderableTargetState<T>>[];
  Offset _position = Offset.zero;
  Offset _lastOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {}

  void _handleDragUpdate(DragUpdateDetails details) {
    final RenderBox box = context.findRenderObject() as RenderBox;

    setState(() {
      _position = Offset(0.0, _position.dy + details.delta.dy);
      _updateDrag(box.localToGlobal(_position));
    });
  }

  Future<void> _handleDragEnd(DragEndDetails details) async {
    // TODO Implement drop action
  }

  void end(DragEndDetails details) {
    finishDrag(_DragEndKind.dropped, details.velocity);
  }

  void cancel() {
    finishDrag(_DragEndKind.canceled);
  }

  void _updateDrag(Offset globalPosition) {
    _lastOffset = globalPosition;
    final HitTestResult result = HitTestResult();
    WidgetsBinding.instance.hitTest(result, globalPosition);

    final List<_ReorderableTargetState<T>> targets =
        _getDragTargets(result.path).toList();

    bool listsMatch = false;
    if (targets.length >= _enteredTargets.length &&
        _enteredTargets.isNotEmpty) {
      listsMatch = true;
      final Iterator<_ReorderableTargetState<T>> iterator = targets.iterator;
      for (int i = 0; i < _enteredTargets.length; i += 1) {
        iterator.moveNext();
        if (iterator.current != _enteredTargets[i]) {
          listsMatch = false;
          break;
        }
      }
    }

    // If everything's the same, report moves, and bail early.
    if (listsMatch) {
      for (final _ReorderableTargetState<T> target in _enteredTargets) {
        target.didMove(this);
      }
      return;
    }

    // Leave old targets.
    _leaveAllEntered();

    // Enter new targets.
    final _ReorderableTargetState<T> newTarget = targets.firstWhere(
      (_ReorderableTargetState<T> target) {
        _enteredTargets.add(target);
        return target.didEnter(this);
      },
      orElse: () => null,
    );

    // Report moves to the targets.
    for (final _ReorderableTargetState<T> target in _enteredTargets) {
      target.didMove(this);
    }

    _activeTarget = newTarget;
  }

  Iterable<_ReorderableTargetState<T>> _getDragTargets(
      Iterable<HitTestEntry> path) sync* {
    // Look for the RenderBoxes that corresponds to the hit target (the hit target
    // widgets build RenderMetaData boxes for us for this purpose).
    for (final HitTestEntry entry in path) {
      final HitTestTarget target = entry.target;
      if (target is RenderMetaData) {
        final dynamic metaData = target.metaData;
        if (metaData is _ReorderableTargetState<T>) yield metaData;
      }
    }
  }

  void _leaveAllEntered() {
    for (int i = 0; i < _enteredTargets.length; i += 1)
      _enteredTargets[i].didLeave(this);
    _enteredTargets.clear();
  }

  void finishDrag(_DragEndKind endKind, [Velocity velocity]) {
    bool wasAccepted = false;
    if (endKind == _DragEndKind.dropped && _activeTarget != null) {
      _activeTarget.didDrop(this);
      wasAccepted = true;
      _enteredTargets.remove(_activeTarget);
    }
    _leaveAllEntered();
    _activeTarget = null;
    // TODO(ianh): consider passing _entry as well so the client can perform an animation.
    if (widget.onDragEnd != null)
      widget.onDragEnd(velocity ?? Velocity.zero, _lastOffset, wasAccepted);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Transform.translate(
      offset: _position,
      child: widget.child,
    );
    // Widget content = Transform.translate(
    //   offset: _position,
    //   child: widget.child,
    // );

    // if (widget.background != null) {
    //   content = Stack(children: <Widget>[
    //     Positioned.fill(
    //       child: widget.background,
    //     ),
    //     content,
    //   ]);
    // }

    return GestureDetector(
      onVerticalDragStart: _handleDragStart,
      onVerticalDragUpdate: _handleDragUpdate,
      onVerticalDragEnd: _handleDragEnd,
      // onPanStart: _handleDragStart,
      // onPanUpdate: _handleDragUpdate,
      // onPanEnd: _handleDragEnd,
      behavior: HitTestBehavior.translucent,
      child: content,
    );
  }
}

class ReorderableTarget<T> extends StatefulWidget {
  ReorderableTarget({
    Key key,
    @required this.child,
    this.onWillAccept,
    this.onAccept,
    this.onAcceptWithDetails,
    this.onLeave,
    this.onMove,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.ease,
  })  : assert(child != null),
        super(key: key);

  final Widget child;

  final DragTargetWillAccept<T> onWillAccept;

  final DragTargetAccept<T> onAccept;

  final DragTargetAcceptWithDetails<T> onAcceptWithDetails;

  final DragTargetLeave onLeave;

  final DragTargetMove onMove;

  final Duration duration;

  final Curve curve;

  @override
  _ReorderableTargetState<T> createState() => _ReorderableTargetState<T>();
}

class _ReorderableTargetState<T> extends State<ReorderableTarget<T>>
    with SingleTickerProviderStateMixin {
  AnimationController _spacingController;
  Animation _spacingAnimation;

  @override
  void initState() {
    assert(widget.duration != null && widget.curve != null);
    _spacingController = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..addStatusListener((status) {
        print(status);
      });
    _spacingAnimation = _spacingController.drive(
      Tween(begin: 0.0, end: 1.0).chain(
        CurveTween(curve: widget.curve),
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _spacingController.dispose();

    super.dispose();
  }

  bool didEnter(_ReorderableItemState<Object> item) {
    print('didEnter');
    if (item is ReorderableItem<T> && widget.onWillAccept != null)
      return widget.onWillAccept(item.widget.data);

    if (!_spacingController.isAnimating) {
      _spacingController.forward();
    }
    return true;
  }

  void didLeave(_ReorderableItemState<Object> item) {
    print('didLeave');
    if (!mounted) return;
    if (widget.onLeave != null) widget.onLeave(item.widget.data as T);

    if (!_spacingController.isAnimating) {
      _spacingController.reverse();
    }
  }

  void didDrop(_ReorderableItemState<Object> item) {
    print('didDrop');
    if (!mounted) return;
    if (widget.onAccept != null) widget.onAccept(item.widget.data as T);
    if (widget.onAcceptWithDetails != null)
      widget.onAcceptWithDetails(DragTargetDetails<T>(
          data: item.widget.data as T, offset: item._lastOffset));
  }

  void didMove(_ReorderableItemState<Object> item) {
    print('didMove');
    if (!mounted) if (!mounted) return;
    if (widget.onMove != null)
      widget.onMove(DragTargetDetails<dynamic>(
          data: item.widget.data, offset: item._lastOffset));
  }

  @override
  Widget build(BuildContext context) {
    final box = context.findRenderObject() as RenderBox;

    final Widget spacing = SizedBox(
      width: (box?.size?.width ?? 100.0),
      height: (box?.size?.height ?? 70.0),
    );

    return Stack(
      children: [
        Column(
          children: [
            MetaData(
              metaData: this,
              behavior: HitTestBehavior.translucent,
              child: spacing,
            ),
            SizeTransition(
              sizeFactor: _spacingAnimation,
              child: spacing,
            ),
          ],
        ),
        widget.child,
      ],
    );
  }
}
