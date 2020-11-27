import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/classes/magnet_scroll_physics.dart';
import 'package:habit_calendar/constants/constants.dart';

class Selector extends StatefulWidget {
  Selector({
    Key key,
    @required this.items,
    this.itemExtent = 40.0,
    this.initialItem = 0,
    this.tagStyle,
    @required this.selectedStyle,
    @required this.unselectedStyle,
    this.tag = '',
    this.scrollDisabled = false,
    this.infinite = false,
    this.duration = const Duration(milliseconds: Constants.smallAnimationSpeed),
    this.curve = Curves.ease,
    this.onIndexChanged,
  })  : assert(items != null),
        assert(selectedStyle != null),
        assert(unselectedStyle != null),
        super(key: key);

  final List<String> items;
  final double itemExtent;
  final int initialItem;
  final bool scrollDisabled;
  final TextStyle tagStyle;
  final TextStyle selectedStyle;
  final TextStyle unselectedStyle;
  final String tag;
  final bool infinite;
  final Duration duration;
  final Curve curve;
  final void Function(int index) onIndexChanged;

  static TextStyle getUnselectedStyle(TextStyle style) {
    return style.copyWith(
      color: Colors.grey,
      fontSize: style.fontSize * 0.8,
      fontWeight: FontWeight.normal,
    );
  }

  @override
  SelectorState createState() => SelectorState();
}

class SelectorState extends State<Selector> {
  ScrollController scrollController;

  Map<int, TextStyle> _itemStyles = Map<int, TextStyle>();
  int _currentIndex;

  TextStyle get _tagStyle => widget.tagStyle ?? Get.textTheme.bodyText1;
  double get _height => widget.itemExtent * 3;

  void _initItemStyles() {
    for (int i = 0; i < widget.items.length; i++) {
      _itemStyles[i] = widget.unselectedStyle;
    }
  }

  int _scrollOffsetToIndex(double offset) {
    /// if offset is negative value. Not expected index can be returned
    /// so just return 0
    if (offset <= 0) return 0;

    // Make offset middle of item
    final _offset = offset.round() + widget.itemExtent / 2;

    return ((_offset / widget.itemExtent) % widget.items.length).floor();
  }

  @override
  void initState() {
    // if infinite mode on. scroll will start at 1000
    _currentIndex = widget.infinite ? widget.items.length * 1000 : 0;
    _currentIndex += widget.initialItem;

    scrollController = ScrollController(
      initialScrollOffset: widget.itemExtent * _currentIndex,
    );

    _initItemStyles();
    _itemStyles[widget.initialItem] = widget.selectedStyle;

    scrollController.addListener(() {
      int newIndex = _scrollOffsetToIndex(scrollController.offset);

      if (_currentIndex != newIndex) {
        _initItemStyles();

        setState(() {
          _itemStyles[newIndex] = widget.selectedStyle;
          _currentIndex = newIndex;
        });

        if (widget.onIndexChanged != null) widget.onIndexChanged(_currentIndex);
      }
    });
    super.initState();
  }

  void _onTap(int index) {
    double _offset;

    if (_scrollOffsetToIndex(scrollController.offset - widget.itemExtent) ==
        index) {
      _offset = scrollController.offset - widget.itemExtent;
    } else if (_scrollOffsetToIndex(
            scrollController.offset + widget.itemExtent) ==
        index) {
      _offset = scrollController.offset + widget.itemExtent;
    } else {
      return;
    }

    scrollController.animateTo(
      _offset,
      duration: widget.duration,
      curve: widget.curve,
    );
  }

  void animateToIndex(int index) {
    final difference = index - _currentIndex;

    final offset = scrollController.offset + difference * widget.itemExtent;

    scrollController.animateTo(
      offset,
      duration: widget.duration,
      curve: widget.curve,
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    if (index == 0 || !widget.infinite && index == widget.items.length + 1) {
      return SizedBox(
        height: widget.itemExtent,
      );
    }

    int _index = 0;
    if (index > 0) _index = (index - 1) % widget.items.length;

    return GestureDetector(
      onTap: widget.scrollDisabled ? null : () => _onTap(_index),
      child: Container(
        color: Colors.transparent,
        height: widget.itemExtent,
        child: Center(
          child: Text(
            widget.items[_index],
            style: _itemStyles[_index],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              widget.tag,
              style: _tagStyle,
            ),
          ),
          Container(
            height: _height,
            child: ScrollConfiguration(
              behavior: ScrollBehavior(),
              child: ListView.builder(
                controller: scrollController,
                physics: widget.scrollDisabled
                    ? NeverScrollableScrollPhysics()
                    : MagnetScrollPhysics(itemSize: widget.itemExtent),
                itemExtent: widget.itemExtent,
                itemCount: widget.infinite ? null : widget.items.length + 2,
                itemBuilder: _itemBuilder,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
