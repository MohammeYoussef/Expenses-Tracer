import 'package:exponse_tracer/data/exponse_data.dart';
import 'package:exponse_tracer/pages/home_page.dart';
import 'package:exponse_tracer/welcomepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();

  await Hive.openBox("expense_database1");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExponseData(),
      builder: (context, child) => MaterialApp(
        title: 'Flutter Demo',
        home: Welcome(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
