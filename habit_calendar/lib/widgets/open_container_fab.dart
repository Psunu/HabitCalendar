import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animations/animations.dart';

class OpenContainerFab extends StatelessWidget {
  static const double _mobileFabDimension = 56;
  final _circleFabBorder = const CircleBorder();
  final Widget openPage;
  final Icon icon;

  OpenContainerFab({this.openPage, this.icon});

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      openBuilder: (context, closedContainer) => openPage,
      closedShape: _circleFabBorder,
      closedColor: Get.theme.accentColor,
      closedElevation: 6,
      closedBuilder: (context, openContainer) {
        return InkWell(
          customBorder: _circleFabBorder,
          onTap: () => openContainer(),
          child: SizedBox(
            width: _mobileFabDimension,
            height: _mobileFabDimension,
            child: Center(
              child: icon,
            ),
          ),
        );
      },
    );
  }
}
