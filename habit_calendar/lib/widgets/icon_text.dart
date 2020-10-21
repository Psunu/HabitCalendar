import 'package:flutter/material.dart';
import 'package:get/get.dart';

const _kIconSize = 30.0;

enum _IconTextType {
  normal,
  description,
}

class IconText extends StatefulWidget {
  IconText({
    Key key,
    @required this.icon,
    @required this.text,
    this.initValue,
    this.iconSize = _kIconSize,
    this.onTap,
    this.onValueChanged,
  })  : assert(icon != null),
        assert(text != null),
        type = _IconTextType.normal,
        // fields for description
        focusNode = null,
        style = null,
        onTextChanged = null,
        descriptionController = null,
        super(key: key);

  IconText.description({
    Key key,
    @required this.icon,
    this.initValue,
    this.iconSize = _kIconSize,
    this.onValueChanged,
    this.focusNode,
    this.descriptionController,
    this.style,
    this.onTextChanged,
  })  : assert(icon != null),
        type = _IconTextType.description,
        // Field for normal
        text = null,
        onTap = null,
        super(key: key);

  // Common fields
  final Icon icon;
  final bool initValue;
  final double iconSize;
  final void Function(bool) onValueChanged;
  final _IconTextType type;

  // Fields for normal
  final Text text;
  final void Function() onTap;

  // Fields for description
  final FocusNode focusNode;
  final TextEditingController descriptionController;
  final TextStyle style;
  final void Function(String) onTextChanged;

  @override
  _IconTextState createState() => _IconTextState();
}

class _IconTextState extends State<IconText> {
  bool _value;

  FocusNode _focusNode;
  TextEditingController _descriptionController;

  @override
  void initState() {
    _value = widget.initValue ?? false;

    _focusNode = widget.focusNode ?? FocusNode();
    _descriptionController =
        widget.descriptionController ?? TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    if (widget.focusNode != null) widget.focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            _value = !_value;

            if (widget.onValueChanged != null) {
              widget.onValueChanged(_value);
            }

            if (widget.type == _IconTextType.description && _value) {
              Get.focusScope.requestFocus(widget.focusNode);
              return;
            }

            Get.focusScope.unfocus();
          },
          child: Icon(
            widget.icon.icon,
            size: widget.icon.size ?? _kIconSize,
            color: _value
                ? widget.icon.color ?? Get.theme.accentColor
                : Colors.grey,
          ),
        ),
        SizedBox(
          width: 30.0,
        ),
        Expanded(
          child: _getTextPart(),
        ),
      ],
    );
  }

  // ignore: missing_return
  Widget _getTextPart() {
    switch (widget.type) {
      case _IconTextType.normal:
        return InkWell(
          onTap: () {
            if (!_value) {
              _value = !_value;

              if (widget.onValueChanged != null) widget.onValueChanged(_value);
            }

            if (widget.onTap != null) widget.onTap();

            Get.focusScope.unfocus();
          },
          child: Text(
            widget.text.data,
            style: widget.text.style?.copyWith(
                  color: _value ? Colors.black87 : Colors.grey,
                ) ??
                Get.textTheme.headline6.copyWith(
                  color: _value ? Colors.black87 : Colors.grey,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        );
      case _IconTextType.description:
        return TextField(
          controller: _descriptionController,
          focusNode: _focusNode,
          keyboardType: TextInputType.text,
          style: widget.style?.copyWith(
                color: _value ? Colors.black87 : Colors.grey,
              ) ??
              Get.textTheme.headline6.copyWith(
                color: _value ? Colors.black87 : Colors.grey,
              ),
          maxLines: null,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
            hintText: '메모'.tr.capitalizeFirst,
            hintStyle: widget.style?.copyWith(
                  color: Colors.grey,
                ) ??
                Get.textTheme.headline6.copyWith(
                  color: Colors.grey,
                ),
            border: InputBorder.none,
          ),
          onChanged: (text) {
            if (text.isEmpty) {
              setState(() {
                _value = false;
                if (widget.onValueChanged != null)
                  widget.onValueChanged(_value);

                if (widget.onTextChanged != null) widget.onTextChanged(text);
              });
            } else if (!_value) {
              setState(() {
                _value = true;
                if (widget.onValueChanged != null)
                  widget.onValueChanged(_value);

                if (widget.onTextChanged != null) widget.onTextChanged(text);
              });
            }
          },
          onEditingComplete: () {
            Get.focusScope.unfocus();
          },
        );
    }
  }
}
