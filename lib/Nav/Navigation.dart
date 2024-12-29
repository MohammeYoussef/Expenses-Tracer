import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int selecteditem = 0;

  List pages = [
    Center(
      child: Text('home'),
    ),
    Center(
      child: Text('bank'),
    ),
    Center(
      child: Text('photo'),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Navigation"),
      ),
      body: pages[selecteditem],
      bottomNavigationBar: Theme(
        data: ThemeData(canvasColor: Colors.cyan),
        child: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              selecteditem = index;
            });
          },
          currentIndex: selecteditem,
          selectedItemColor: Colors.black,
          showUnselectedLabels: true,
          unselectedItemColor: Colors.white,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_balance), label: 'Bank'),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_a_photo), label: 'photo')
          ],
        ),
      ),
    );
  }
}
