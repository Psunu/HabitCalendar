import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/controllers/manage_habit_controller.dart';
import 'package:habit_calendar/widgets/project_purpose/bottom_bar.dart';
import 'package:habit_calendar/widgets/project_purpose/delete_confirm_dialog.dart';

import '../widgets/general_purpose/auto_colored_icon.dart';
import '../widgets/general_purpose/auto_colored_text.dart';
import '../widgets/project_purpose/group_card.dart';

class ManageHabit extends StatefulWidget {
  @override
  _ManageHabitState createState() => _ManageHabitState();
}

class _ManageHabitState extends State<ManageHabit>
    with TickerProviderStateMixin {
  AnimationController _bottomBarController;
  Animation _bottomBarAnimation;
  AnimationController _confirmController;
  Animation _confirmAnimation;

  OverlayEntry _bottomBar;
  OverlayEntry _confirmDialog;

  ManageHabitController _controller;

  void _showConfirmDialog() async {
    try {
      Overlay.of(context).insert(_confirmDialog);
    } catch (e) {
      print('ERROR: Overlay is not inserted');
    }

    await _bottomBarController.reverse();
    await _confirmController.forward();
  }

  void _closeConfirmDialog({@required bool isCanceled}) async {
    await _confirmController.reverse();
    await _bottomBarController.forward();

    try {
      _confirmDialog.remove();
    } catch (e) {
      print('ERROR: Overlay is not inserted');
    }

    if (!isCanceled) _controller.isEditMode.value = false;
  }

  void _buildConfirmDialog() {
    _confirmDialog = OverlayEntry(builder: (context) {
      return Positioned(
        bottom: 0.0,
        child: SizeTransition(
          sizeFactor: _confirmAnimation,
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: DeleteConfirmDialog(
              message: AutoColoredText(
                backgroundColor: Get.theme.scaffoldBackgroundColor,
                child: Text(
                  '삭제하시겠어요?'.tr,
                  style: Get.textTheme.bodyText1,
                ),
              ),
              backgroundColor: Get.theme.scaffoldBackgroundColor,
              onCancelTap: () {
                _closeConfirmDialog(isCanceled: true);
              },
              onDeleteTap: () {
                _closeConfirmDialog(isCanceled: false);
                _controller.onDeleteTapped();
              },
            ),
          ),
        ),
      );
    });
  }

  void _showBottomBar() {
    try {
      Overlay.of(context).insert(_bottomBar);
    } catch (e) {
      print('ERROR: The specified entry is already present in the Overlay.');
    }
    _bottomBarController.forward();
  }

  void _closeBottomBar() async {
    try {
      await _bottomBarController.reverse();
      _bottomBar.remove();
    } catch (e) {
      print('ERROR: Overlay is not inserted');
    }
  }

  void _buildBottomBar() {
    _bottomBar = OverlayEntry(builder: (context) {
      return Positioned(
        bottom: 0.0,
        child: SizeTransition(
          sizeFactor: _bottomBarAnimation,
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: BottomBar(
              backgroundColor: Get.theme.scaffoldBackgroundColor,
              onDeleteTap: _showConfirmDialog,
            ),
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    // Init Get controller
    _controller = ManageHabitController();
    // Init LayoutEntries
    _buildConfirmDialog();
    _buildBottomBar();

    // Init Animations
    _bottomBarController = AnimationController(
      duration: Duration(milliseconds: Constants.mediumAnimationSpeed),
      vsync: this,
    );
    _bottomBarAnimation = _bottomBarController.drive(
      Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.ease)),
    );

    _confirmController = AnimationController(
      duration: Duration(milliseconds: Constants.mediumAnimationSpeed),
      vsync: this,
    );
    _confirmAnimation = _confirmController.drive(
      Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.ease)),
    );

    // Add listener
    _controller.isEditMode.listen((value) async {
      if (value) {
        _showBottomBar();
      } else {
        _closeBottomBar();
        _closeConfirmDialog(isCanceled: true);
      }
    });

    _controller.selectedGroups.listen((map) {
      int numSelected = 0;
      map.forEach((key, value) {
        if (value) numSelected++;
      });
      if (numSelected == 0)
        _bottomBarController.reverse();
      else
        _bottomBarController.forward();
    });

    super.initState();
  }

  @override
  void dispose() {
    _bottomBarController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetX<ManageHabitController>(
      init: _controller,
      builder: (controller) => WillPopScope(
        onWillPop: controller.onWillPop,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Get.theme.scaffoldBackgroundColor,
            elevation: 0.0,
            centerTitle: true,
            leading: IconButton(
              icon: AutoColoredIcon(
                backgroundColor: Get.theme.scaffoldBackgroundColor,
                child: Icon(
                  Icons.arrow_back,
                  color: Get.textTheme.bodyText1.color,
                ),
              ),
              onPressed: () {
                // _closeBottomBar();
                controller.isEditMode.value = false;
                Get.back();
              },
            ),
            actions: [
              controller.isEditMode.value
                  ? IconButton(
                      icon: AutoColoredIcon(
                        backgroundColor: Get.theme.scaffoldBackgroundColor,
                        child: Icon(
                          Icons.clear,
                          color: Get.textTheme.bodyText1.color,
                        ),
                      ),
                      onPressed: () async {
                        await controller.onWillPop();
                      },
                    )
                  : Container(),
            ],
            title: AutoColoredText(
              backgroundColor: Get.theme.scaffoldBackgroundColor,
              child: Text(
                '폴더'.tr.capitalizeFirst,
                style: Get.textTheme.headline6,
              ),
            ),
          ),
          floatingActionButton: AnimatedOpacity(
            duration: Duration(milliseconds: Constants.mediumAnimationSpeed),
            opacity: controller.isEditMode.value ? 0.0 : 1.0,
            child: FloatingActionButton(
              onPressed: controller.onAddGroupTapped,
              child: Icon(Icons.add),
            ),
          ),
          body: Container(
            padding: const EdgeInsets.only(
              top: Constants.padding,
              bottom: Constants.padding + 50.0,
            ),
            child: ReorderableList(
              onReorder: controller.reorderCallback,
              onReorderDone: controller.reorderDone,
              decoratePlaceholder: (widget, opacity) {
                return DecoratedPlaceholder(widget: widget, offset: 0.0);
              },
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: controller.groups.length,
                itemBuilder: (context, index) {
                  final group = controller.groups[index];

                  return ReorderableItem(
                    key: ValueKey(group.id),
                    childBuilder: (context, state) {
                      return controller.buildReorderItemChild(
                        /// To reflect controller.habits changes use Obx
                        /// Maybe because it is returned from builder.
                        /// it is at out of GetX Widget.
                        /// so it can't listen to controller's Rx property
                        Obx(() => Padding(
                              key: ValueKey(group.id),
                              padding: const EdgeInsets.fromLTRB(
                                Constants.padding,
                                0.0,
                                Constants.padding,
                                8.0,
                              ),
                              child: GroupCard(
                                group: group,
                                memberHabits: controller.groupMembersOf(
                                  group.id,
                                ),
                                colorCircleSize: 20.0,
                                height: 70.0,
                                editModeAction: ReorderableListener(
                                  child: Center(
                                    child: Icon(Icons.reorder),
                                  ),
                                ),
                                isSelected:
                                    controller.selectedGroups[group.id] ??
                                        false,
                                onHabitTapped: controller.onHabitTapped,
                                isEditMode: controller.isEditMode.value,
                                onLongPress: controller.onLongPress,
                                onTapAfterLongPress:
                                    controller.onTapAfterLongPress,
                              ),
                            )),
                        context,
                        state,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
