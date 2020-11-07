import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';

class Utils {
  static String getFormedDate(DateTime date) {
    if (Get.locale.languageCode == 'ko') {
      return '${date.month}월 ${date.day}일 (${Utils.getWeekString(date.weekday - 1)})';
    } else {
      return '${date.day} ${getMonthStringEn(date.month)} (${Utils.getWeekString(date.weekday - 1)})';
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

  static String getWeekString(int week) {
    switch (week) {
      case 0:
        return '월'.tr.capitalizeFirst;
      case 1:
        return '화'.tr.capitalizeFirst;
      case 2:
        return '수'.tr.capitalizeFirst;
      case 3:
        return '목'.tr.capitalizeFirst;
      case 4:
        return '금'.tr.capitalizeFirst;
      case 5:
        return '토'.tr.capitalizeFirst;
      case 6:
        return '일'.tr.capitalizeFirst;
    }
    return '월'.tr.capitalizeFirst;
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
      return '${Utils.twoDigits(whatTime.hour)}:${Utils.twoDigits(whatTime.minute)}';
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

  static Future<T> customShowModalBottomSheet<T>(
      {@required void Function(BuildContext) builder}) {
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

  static Future<T> customShowModal<T>(
      {Widget Function(BuildContext context) builder}) {
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
