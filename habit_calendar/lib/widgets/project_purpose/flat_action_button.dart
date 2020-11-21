import 'package:flutter/material.dart';

class FlatActionButton extends StatelessWidget {
  FlatActionButton({
    Key key,
    this.width,
    this.height,
    this.widthBetween = 5.0,
    this.icon,
    this.text,
    this.onTap,
  })  : assert(icon != null),
        assert(text != null),
        super(key: key);

  final double width;
  final double height;
  final double widthBetween;
  final Widget icon;
  final Widget text;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        child: Row(
          children: [
            icon,
            SizedBox(
              width: widthBetween,
            ),
            text,
          ],
        ),
      ),
    );
  }
}
