import 'package:exponse_tracer/Components/Exponse_tile.dart';
import 'package:exponse_tracer/Components/expense_summary.dart';
import 'package:exponse_tracer/data/exponse_data.dart';
import 'package:exponse_tracer/models/exponse_item.dart';
import 'package:exponse_tracer/pages/notes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // State variable to track selected index

  final newExponseNameController = TextEditingController();
  final newExponseAmountController = TextEditingController();
  final _key = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ExponseData>(context, listen: false).prepareData();
  }

  void addNewExponse() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Exponse'),
        content: Form(
          key: _key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) return "must be fiiled";
                  return null;
                },
                decoration: InputDecoration(hintText: 'Expense name'),
                controller: newExponseNameController,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) return "must be fiiled";
                  return null;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: 'Amount'),
                controller: newExponseAmountController,
              ),
            ],
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              if (_key.currentState!.validate()) {
                _key.currentState!.save();
                save();
              }
            },
            child: Text("Save"),
          ),
          MaterialButton(
            onPressed: cancel,
            child: Text("Cancel"),
          )
        ],
      ),
    );
  }

  //delete expense
  void deleteExpense(ExponseItem expense) {
    Provider.of<ExponseData>(context, listen: false).deleteExponse(expense);
  }

  void save() {
    ExponseItem newExponse = ExponseItem(
      name: newExponseNameController.text,
      amount: newExponseAmountController.text,
      dateTime: DateTime.now(),
    );
    Provider.of<ExponseData>(context, listen: false)
        .addNewExponseItem(newExponse);
    Navigator.of(context).pop();
    clear();
  }

  void cancel() {
    Navigator.of(context).pop();
  }

  void clear() {
    newExponseNameController.clear();
    newExponseAmountController.clear();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the desired page based on the selected index
    if (index == 1) {
      // Navigate to Notes page
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Notes(),
      )); // Replace '/notes' with the actual route name for your Notes page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExponseData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Color(0xffDDDCDD),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.cyan,
          onPressed: addNewExponse,
          child: const Icon(Icons.add),
        ),
        body: ListView(
          children: [
            // weekly summary
            ExpensesSummary(startWeekdate: value.startWeekdate()),
            const SizedBox(
              height: 20,
            ),
            // expense list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: value.getAllExonseList().length,
              itemBuilder: (context, index) => ExponseTile(
                name: value.getAllExonseList()[index].name,
                amount: value.getAllExonseList()[index].amount,
                dateTime: value.getAllExonseList()[index].dateTime,
                deleteTapped: (p0) =>
                    deleteExpense(value.getAllExonseList()[index]),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          // Add the bottom navigation bar
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_note_outlined),
              label: 'Notes',
            ),
          ],
          iconSize: 35,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex, // Set initial selected index
          selectedItemColor: Colors.cyan, // Customize colors as desired
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped, // Handle tapping on bottom navigation bar items
        ),
      ),
    );
  }
}
