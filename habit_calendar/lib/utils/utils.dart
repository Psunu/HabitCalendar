import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/enums/day_of_the_week.dart';

class Utils {
  static String getFormedDate(DateTime date) {
    if (Get.locale.languageCode == 'ko') {
      return '${date.month}월 ${date.day}일 (${Utils.getWeekString(DayOfTheWeek.values[date.weekday - 1])})';
    } else {
      return '${date.day} ${getMonthStringEn(date.month)} (${Utils.getWeekString(DayOfTheWeek.values[date.weekday - 1])})';
    }
  }

  static String getMonthStringEn(int month) {
    switch (month) {
      case 1:
        return 'JAN';
      case 2:
        return 'FEB';
      case 3:
        return 'MAR';
      case 4:
        return 'APR';
      case 5:
        return 'MAY';
      case 6:
        return 'JUN';
      case 7:
        return 'JUL';
      case 8:
        return 'AUG';
      case 9:
        return 'SEP';
      case 10:
        return 'OCT';
      case 11:
        return 'NOV';
      case 12:
        return 'DEC';
    }
    return 'JAN';
  }

  static String getWeekString(DayOfTheWeek week) {
    switch (week) {
      case DayOfTheWeek.Mon:
        return '월'.tr.capitalizeFirst;
      case DayOfTheWeek.Tue:
        return '화'.tr.capitalizeFirst;
      case DayOfTheWeek.Wed:
        return '수'.tr.capitalizeFirst;
      case DayOfTheWeek.Thu:
        return '목'.tr.capitalizeFirst;
      case DayOfTheWeek.Fri:
        return '금'.tr.capitalizeFirst;
      case DayOfTheWeek.Sat:
        return '토'.tr.capitalizeFirst;
      case DayOfTheWeek.Sun:
        return '일'.tr.capitalizeFirst;
    }
    return '월'.tr.capitalizeFirst;
  }

  static String getWeekStringEn(DayOfTheWeek week) {
    switch (week) {
      case DayOfTheWeek.Mon:
        return 'Mon';
      case DayOfTheWeek.Tue:
        return 'Tue';
      case DayOfTheWeek.Wed:
        return 'Wed';
      case DayOfTheWeek.Thu:
        return 'Thu';
      case DayOfTheWeek.Fri:
        return 'Fri';
      case DayOfTheWeek.Sat:
        return 'Sat';
      case DayOfTheWeek.Sun:
        return 'Sun';
    }
    return 'Mon';
  }

  static String getWhatTimeString(DateTime whatTime) {
    return '${getAmPm(whatTime)} ${getFormedWhatTime(whatTime)}';
  }

  static String getNotificationTimeString(Duration notificationTime) {
    int hours = notificationTime.inHours;
    int minutes = (notificationTime - Duration(hours: hours)).inMinutes;

    String result = '';

    if (Get.locale.languageCode == 'ko') {
      if (hours > 0) {
        result += '$hours ' + '시간'.tr + ' ';
      } else if (minutes < 1) {
        return '즉시 알림'.tr;
      }
      result += '$minutes 분 전에 알림';
    } else {
      if (hours > 0) {
        result += 'Notify ';

        if (hours == 1)
          result += '$hours ' + 'hour' + ' ';
        else
          result += '$hours ' + 'hours' + ' ';
      } else if (minutes < 1) {
        return '즉시 알림'.tr;
      }

      if (minutes < 2)
        result += '$minutes minute ago';
      else
        result += '$minutes minutes ago';
    }

    return result;
  }

  static String getFormedWhatTime(DateTime whatTime) {
    if (whatTime == null) return '오늘안에'.tr.capitalizeFirst;
    if (whatTime.hour < 13)
      return '${Utils.twoDigits(whatTime.hour == 0 ? 12 : whatTime.hour)}:${Utils.twoDigits(whatTime.minute)}';
    else
      return '${Utils.twoDigits(whatTime.hour - 12)}:${Utils.twoDigits(whatTime.minute)}';
  }

  static String getAmPm(DateTime whatTime) {
    if (whatTime == null) return '';
    return whatTime.hour < 12 ? '오전'.tr.toUpperCase() : '오후'.tr.toUpperCase();
  }

  static String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  static Future<T> customShowModalBottomSheet<T>({
    @required Widget Function(BuildContext) builder,
  }) {
    return showModalBottomSheet<T>(
      context: Get.context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(Constants.largeBorderRadius),
          topRight: const Radius.circular(Constants.largeBorderRadius),
        ),
      ),
      builder: builder,
    );
  }

  static Future<T> customShowModal<T>({
    @required Widget Function(BuildContext context) builder,
  }) {
    return showModal<T>(
      context: Get.context,
      configuration: FadeScaleTransitionConfiguration(),
      builder: (context) => Center(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            // This padding works like resizeToAvoidBottomInset
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                    Constants.padding,
                    Constants.padding,
                    Constants.padding,
                    Constants.padding / 2),
                margin: const EdgeInsets.all(Constants.padding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    Constants.largeBorderRadius,
                  ),
                ),
                child: builder(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension zeroing on DateTime {
  DateTime zeroDay() => DateTime(this.year, this.month, this.day);
  DateTime zeroMonth() => DateTime(this.year, this.month);
  DateTime zeroYear() => DateTime(this.year);

  DateTime firstDayOfWeek({DayOfTheWeek startWeek = DayOfTheWeek.Sun}) {
    int subtractDays = 0;
    if (startWeek.index != this.weekday - 1 && startWeek != DayOfTheWeek.Mon) {
      subtractDays = DayOfTheWeek.Sun.index - (startWeek.index - 1);
      subtractDays += this.weekday - 1;
    }

    return this.subtract(Duration(days: subtractDays)).zeroDay();
  }
}
