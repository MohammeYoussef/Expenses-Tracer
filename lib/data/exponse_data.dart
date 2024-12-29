import 'package:exponse_tracer/data/hive_database.dart';
import 'package:exponse_tracer/date_time_helper/date_time_helper.dart';
import 'package:flutter/material.dart';

import '../models/exponse_item.dart';

class ExponseData extends ChangeNotifier {
  List<ExponseItem> overallExponseList = [];

  List<ExponseItem> getAllExonseList() {
    return overallExponseList;
  }

  final db = HiveDataBase();
  void prepareData() {
    if (db.readData().isNotEmpty) {
      overallExponseList = db.readData();
    }
  }

  void addNewExponseItem(ExponseItem newExpose) {
    overallExponseList.add(newExpose);
    notifyListeners();
    db.saveData(overallExponseList);
  }

  void deleteExponse(ExponseItem exponse) {
    overallExponseList.remove(exponse);
    notifyListeners();
    db.saveData(overallExponseList);
  }

  String getDaName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thur';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  DateTime startWeekdate() {
    DateTime? startofweek;
    DateTime today = DateTime.now();
    for (int i = 0; i < 7; i++) {
      if (getDaName(today.subtract(Duration(days: i))) == 'Sun') {
        startofweek = today.subtract(Duration(days: i));
      }
    }
    return startofweek!;
  }

  Map<String, double> calculateDailyExponseSummary() {
    Map<String, double> dailyExponseSummary = {};
    for (var exponse in overallExponseList) {
      String? date = convertDateTimetoString(exponse.dateTime);
      double amount = double.parse(exponse.amount);

      if (dailyExponseSummary.containsKey(date)) {
        double currentAmount = dailyExponseSummary[date]!;
        currentAmount += amount;
        dailyExponseSummary[date.toString()] = currentAmount;
      } else {
        dailyExponseSummary.addAll({date.toString(): amount});
      }
    }
    return dailyExponseSummary;
  }
}
