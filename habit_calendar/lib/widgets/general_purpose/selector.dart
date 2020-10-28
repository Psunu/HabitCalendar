import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Selector extends StatefulWidget {
  Selector({
    @required this.controller,
    @required this.items,
    this.itemExtent = 40.0,
    this.height,
    this.scrollDisabled = false,
    @required this.tagStyle,
    @required this.selectedStyle,
    @required this.unselectedStyle,
    this.tag = '',
  })  : assert(controller != null),
        assert(items != null),
        assert(selectedStyle != null),
        assert(unselectedStyle != null);

  final FixedExtentScrollController controller;
  final List<String> items;
  final double itemExtent;
  final double height;
  final bool scrollDisabled;
  final TextStyle tagStyle;
  final TextStyle selectedStyle;
  final TextStyle unselectedStyle;
  final String tag;

  static TextStyle getUnselectedStyle(TextStyle style) {
    return style.copyWith(
      color: Colors.grey,
      fontSize: style.fontSize * 0.9,
    );
  }

  @override
  _SelectorState createState() => _SelectorState();
}

class _SelectorState extends State<Selector> {
  TextStyle get _tagStyle => widget.tagStyle ?? Get.textTheme.bodyText1;
  double get _height => widget.height ?? widget.itemExtent * 5;

  Map<int, TextStyle> _itemStyles = Map<int, TextStyle>();

  @override
  void initState() {
    _initItemStyles();
    _itemStyles[widget.controller.initialItem] = widget.selectedStyle;

    widget.controller.addListener(() {
      _initItemStyles();
      setState(() {
        _itemStyles[widget.controller.selectedItem] = widget.selectedStyle;
      });
    });
    super.initState();
  }

  void _initItemStyles() {
    for (int i = 0; i < widget.items.length; i++) {
      _itemStyles[i] = widget.unselectedStyle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.tag,
              style: _tagStyle,
            ),
          ),
          Container(
            height: _height,
            child: ScrollConfiguration(
              behavior: ScrollBehavior(),
              child: ListWheelScrollView(
                perspective: 0.009,
                controller: widget.controller,
                physics: widget.scrollDisabled
                    ? NeverScrollableScrollPhysics()
                    : FixedExtentScrollPhysics(),
                itemExtent: widget.itemExtent,
                children: List.generate(
                  widget.items.length,
                  (index) => Container(
                    height: widget.itemExtent,
                    child: Center(
                      child: Text(
                        widget.items[index],
                        style: _itemStyles[index],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
