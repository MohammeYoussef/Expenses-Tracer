import 'package:exponse_tracer/barGraph/bar_graph.dart';
import 'package:exponse_tracer/data/exponse_data.dart';
import 'package:exponse_tracer/date_time_helper/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpensesSummary extends StatelessWidget {
  final DateTime startWeekdate;
  const ExpensesSummary({
    super.key,
    required this.startWeekdate,
  });

  //calculate the week total;

  String calculateWeekTotal(
    ExponseData value,
    String sunday,
    String monday,
    String tuesday,
    String wednesday,
    String thursday,
    String friday,
    String saturday,
  ) {
    List<double> values = [
      value.calculateDailyExponseSummary()[sunday] ?? 0,
      value.calculateDailyExponseSummary()[monday] ?? 0,
      value.calculateDailyExponseSummary()[tuesday] ?? 0,
      value.calculateDailyExponseSummary()[wednesday] ?? 0,
      value.calculateDailyExponseSummary()[thursday] ?? 0,
      value.calculateDailyExponseSummary()[friday] ?? 0,
      value.calculateDailyExponseSummary()[saturday] ?? 0,
    ];
    double total = 0;
    for (int i = 0; i < values.length; i++) {
      total += values[i];
    }
    return total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    var sunday =
        convertDateTimetoString(startWeekdate.add(const Duration(days: 0)));
    var monday =
        convertDateTimetoString(startWeekdate.add(const Duration(days: 1)));
    var tuesday =
        convertDateTimetoString(startWeekdate.add(const Duration(days: 2)));
    var wedday =
        convertDateTimetoString(startWeekdate.add(const Duration(days: 3)));
    var thursday =
        convertDateTimetoString(startWeekdate.add(const Duration(days: 4)));
    var friday =
        convertDateTimetoString(startWeekdate.add(const Duration(days: 5)));
    var satday =
        convertDateTimetoString(startWeekdate.add(const Duration(days: 6)));
    return Consumer<ExponseData>(
      builder: (context, value, child) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 50, 25, 25),
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.cyan,
                    Colors.white,
                  ]),
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.cyan),
              padding: EdgeInsets.all(10),
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Week Total: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    '${calculateWeekTotal(value, sunday!, monday!, tuesday!, wedday!, thursday!, friday!, satday!)}',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 200,
            child: MyBarGraph(
              maxY: 100,
              sunAmount: value.calculateDailyExponseSummary()[sunday] ?? 0,
              monAmount: value.calculateDailyExponseSummary()[monday] ?? 0,
              tueAmount: value.calculateDailyExponseSummary()[tuesday] ?? 0,
              wedAmount: value.calculateDailyExponseSummary()[wedday] ?? 0,
              thurAmount: value.calculateDailyExponseSummary()[thursday] ?? 0,
              friAmount: value.calculateDailyExponseSummary()[friday] ?? 0,
              satAmount: value.calculateDailyExponseSummary()[satday] ?? 0,
            ),
          ),
        ],
      ),
    );
  }
}
