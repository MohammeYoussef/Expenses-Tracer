import 'package:exponse_tracer/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffDDDCDD),
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.moneyBills,
              size: 150,
            ),
            Text(
              "Your Expense",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text("Companion", style: TextStyle(fontSize: 20)),
            SizedBox(
              height: 10,
            ),
            Text(
              "Tracking expenses!",
              style: TextStyle(color: Colors.grey[600], fontSize: 15),
            ),
            SizedBox(
              height: 130,
            ),
            FloatingActionButton(
              backgroundColor: Colors.cyan,
              child: Icon(
                Icons.arrow_circle_right_sharp,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HomePage(),
                ));
              },
            ),
          ],
        ),
      )),
    );
  }
}
