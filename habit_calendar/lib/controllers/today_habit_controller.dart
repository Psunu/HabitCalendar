import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/enums/completion.dart';
import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/services/database/db_service.dart';
import 'package:habit_calendar/utils/utils.dart';
import 'package:habit_calendar/views/manage_habit_view.dart';
import 'package:habit_calendar/widgets/project/habit_tile.dart';

import '../enums/day_of_the_week.dart';

const _kHabitTileThreshHold = 0.2;
const _kHabitTileBackgroundIconSize = 30.0;

class TodayHabitController extends GetxController {
  TodayHabitController({
    GlobalKey<SliverAnimatedListState> listKey,
  }) : listKey = listKey ?? GlobalKey<SliverAnimatedListState>();

  final DbService _dbService = Get.find<DbService>();

  DateTime today = DateTime.now();
  final todayHabits = List<Habit>().obs;
  final todayEvents = List<Event>().obs;

  GlobalKey<SliverAnimatedListState> listKey;
  List<Habit> habitsCache = List<Habit>();
  int latestChangedHabitId;

  final enableIndicator = false.obs;

  /// animationControllers is map to keep every each HabitTile animation controllers
  /// key : habit id, value : animation controller
  Map<int, AnimationController> animationControllers =
      Map<int, AnimationController>();

  // Get Set
  String get formedToday => Utils.getFormedDate(today);

  int get completedEvent => todayEvents
      .where((element) => element.completion != Completion.No.index)
      .length;

  double get todayPercentage {
    if (todayEvents.length == 0 || todayHabits.length == 0) return 0;
    return completedEvent / todayHabits.length;
  }

  double get _backgroundIconPadding =>
      (((Get.width - (Constants.padding * 2)) * _kHabitTileThreshHold) -
          _kHabitTileBackgroundIconSize) /
      2;

  // Controller life cycle
  @override
  void onInit() async {
    today = DateTime(today.year, today.month, today.day);

    todayHabits.bindStream(_dbService.database.habitDao
        .watchHabitsByWeek(DayOfTheWeek.values[today.weekday - 1])
        .map((event) => _sortTodayHabits(event)));
    todayEvents
        .bindStream(_dbService.database.eventDao.watchEventsByDate(today));

    /// When AnimatedList builded initialItemCount is 0. because todayHabits is kind of Stream.
    /// so at that time todayHabits has nothing.
    /// after todayHabits is loaded listen callback is called and habitsCache is null.
    /// therefore all initial todayHabits entries are loaded to AnimatedList
    todayHabits.listen((list) {
      Map<int, Habit> removed = Map<int, Habit>();
      Map<int, Habit> added = Map<int, Habit>();

      // Load inital todayHabits entries to AnimatedList
      if (habitsCache.isNull || habitsCache.isEmpty) {
        for (int i = 0; i < list.length; i++) {
          added[i] = list[i];
        }
      } else {
        /// Check removed habits
        /// if habitsCache has but new todayHabits doesn't. it is removed
        for (int i = 0; i < habitsCache.length; i++) {
          if (!list.contains(habitsCache[i])) {
            removed[i] = habitsCache[i];
          }
        }

        /// Check added habits
        /// if new todayHabits has but habitsCache doesn't. it is added
        for (int i = 0; i < list.length; i++) {
          if (!habitsCache.contains(list[i])) {
            added[i] = list[i];
          }
        }
      }

      // Remove all removed habits from AnimatedList
      removed.forEach((key, value) {
        listKey.currentState.removeItem(
          key,
          (context, animation) => buildItem(value, animation),
          duration:
              const Duration(milliseconds: Constants.mediumAnimationSpeed),
        );
      });

      // Insert all added habits to AnimatedList
      added.forEach((key, value) {
        listKey.currentState.insertItem(
          key,
          duration:
              const Duration(milliseconds: Constants.mediumAnimationSpeed),
        );
      });

      // Update habitsCache
      habitsCache = list;
    });

    /// When Events added because of HabitTile action. todayHabits should be resorted.
    /// Check whether habit should be moved or not by compare before sort index and after sort index.
    /// If habit should be moved. remove habit from AnimatedList at before sort index
    /// and insert to AnimatedList at after sort index
    todayEvents.listen((list) {
      // Get before sort index
      int oldIndex = todayHabits
          .indexWhere((element) => element.id == latestChangedHabitId);

      // Sort todayHabits
      _sortTodayHabits(todayHabits);

      // Get after sort index
      int newIndex = todayHabits
          .indexWhere((element) => element.id == latestChangedHabitId);

      /// if before sort index is not equal after sort index
      /// it shuld be moved
      if (oldIndex != newIndex) {
        listKey.currentState.removeItem(
          oldIndex,
          (context, animation) => buildItem(todayHabits[oldIndex], animation),
          duration:
              const Duration(milliseconds: Constants.mediumAnimationSpeed),
        );
        listKey.currentState.insertItem(
          newIndex,
          duration:
              const Duration(milliseconds: Constants.mediumAnimationSpeed),
        );
      }
    });

    super.onInit();
  }

  @override
  void onClose() {
    animationControllers.forEach((key, value) {
      value.dispose();
    });
    super.onClose();
  }

  // Primary methods
  Future<void> complete(int habitId) async {
    showIndicator();

    if (todayEvents
        .where(
          (event) => _eventsWhere(event, habitId),
        )
        .isEmpty) {
      await _dbService.database.eventDao.insertEvent(
        Event(
          id: null,
          date: today,
          completion: Completion.Ok.index,
          habitId: habitId,
        ),
      );
    }
  }

  Future<void> notComplete(int habitId) async {
    showIndicator();

    Event event = todayEvents.singleWhere(
      (event) => _eventsWhere(event, habitId),
      orElse: () => null,
    );

    if (event != null) {
      _dbService.database.eventDao.deleteEvent(event);
    }
  }

  void showIndicator() async {
    if (enableIndicator.value == true) return;

    enableIndicator.value = true;
    await Future.delayed(Duration(seconds: 2));
    enableIndicator.value = false;
  }

  void navigateToManage() {
    final route = PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          ManageHabitView(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final begin = Offset(-1.0, 0.0);
        final end = Offset.zero;
        final curve = Curves.ease;

        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
    Navigator.of(Get.context).push(route);
  }

  // Utility Methods
  Widget buildItem(Habit habit, Animation<double> animation) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.ease),
      child: SizeTransition(
        sizeFactor: CurvedAnimation(parent: animation, curve: Curves.ease),
        child: Padding(
          padding: const EdgeInsets.only(
            left: Constants.padding,
            right: Constants.padding,
            bottom: 20.0,
          ),
          child: HabitTile(
            height: 70.0,
            key: ValueKey(habit.id),
            slideThreshold: _kHabitTileThreshHold,
            ampm: Text(
              Utils.getAmPm(habit.whatTime),
              style: Get.textTheme.bodyText1.copyWith(
                fontSize: Get.textTheme.bodyText1.fontSize * 0.8,
              ),
            ),
            whatTime: Text(
              Utils.getFormedWhatTime(habit.whatTime),
              style: Get.textTheme.bodyText1,
            ),
            name: Text(
              habit.name,
              style: Get.textTheme.bodyText1,
            ),
            checkMark: Icon(
              Icons.radio_button_unchecked,
              color: Get.theme.accentColor,
              size: 60.0,
            ),
            background: HabitTileBackground(
              color: Get.theme.accentColor,
              child: Padding(
                padding: EdgeInsets.only(
                  right: _backgroundIconPadding,
                ),
                child: RotationTransition(
                  turns: Tween(begin: 0.0, end: -0.3).animate(
                    CurvedAnimation(
                        parent: animationControllers[habit.id],
                        curve: Curves.ease),
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    color: Get.theme.scaffoldBackgroundColor,
                    size: _kHabitTileBackgroundIconSize,
                  ),
                ),
              ),
            ),
            secondaryBackground: HabitTileBackground(
              color: Color(Constants.secondaryAccentColor),
              child: Padding(
                padding: EdgeInsets.only(
                  right: _backgroundIconPadding,
                ),
                child: RotationTransition(
                  turns: Tween(begin: 0.0, end: -0.3).animate(
                    CurvedAnimation(
                        parent: animationControllers[habit.id],
                        curve: Curves.ease),
                  ),
                  child: Icon(
                    Icons.replay,
                    color: Get.theme.scaffoldBackgroundColor,
                    size: _kHabitTileBackgroundIconSize,
                  ),
                ),
              ),
            ),
            initBackground: isCompleted(habit.id)
                ? HabitTileBackgroundType.secondaryBackground
                : HabitTileBackgroundType.background,
            onBackgroundChangedAnimation: (from, to) async {
              await animationControllers[habit.id].forward();
              return animationControllers[habit.id].reverse();
            },
            onBackgroundChanged: (from, to) {
              switch (from) {
                case HabitTileBackgroundType.background:
                  complete(habit.id);
                  break;
                case HabitTileBackgroundType.secondaryBackground:
                  notComplete(habit.id);
                  break;
              }
              latestChangedHabitId = habit.id;
            },
          ),
        ),
      ),
    );
  }

  bool isCompleted(int habitId) {
    return todayEvents
                .singleWhere(
                  (event) => _eventsWhere(event, habitId),
                  orElse: () => null,
                )
                ?.completion ==
            Completion.Ok.index ??
        false;
  }

  bool _eventsWhere(Event event, int habitId) {
    if (event == null) return false;

    return event.date.isAtSameMomentAs(today) && event.habitId == habitId;
  }

  List<Habit> _sortTodayHabits(List<Habit> list) {
    list.sort((a, b) {
      final aEvent = todayEvents.singleWhere(
          (event) => _eventsWhere(event, a.id),
          orElse: () => null);
      final bEvent = todayEvents.singleWhere(
          (event) => _eventsWhere(event, b.id),
          orElse: () => null);

      // 1st Sort : Sort by event is completed
      // Move habit that is completed to end of list
      if (aEvent.isNull && !bEvent.isNull)
        return -1;
      else if (bEvent.isNull && !aEvent.isNull)
        return 1;
      // 2nd Sort : Sort by whatTime is not null
      // Move habit has whatTime is null to end of list
      else {
        if (a.whatTime.isNull && !b.whatTime.isNull)
          return 1;
        else if (b.whatTime.isNull && !a.whatTime.isNull)
          return -1;
        // 3rd Sort : Sort by whatTime
        // Move habit has more late whatTime to end of list
        else {
          int value = a.whatTime?.compareTo(b.whatTime) ?? 0;
          if (value != 0)
            return value;
          // 4th Sort : Sort by name alphabet
          else
            return a.name.compareTo(b.name);
        }
      }
    });
    return list;
  }
}
