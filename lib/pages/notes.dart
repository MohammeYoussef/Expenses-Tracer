import 'package:exponse_tracer/Controller/dbcontroller.dart';
import 'package:exponse_tracer/models/notesmodel.dart';
import 'package:exponse_tracer/pages/home_page.dart';
import 'package:flutter/material.dart';

class Notes extends StatefulWidget {
  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  int _selectedIndex = 1;
  TextEditingController notes_name = TextEditingController();
  TextEditingController notes_amount = TextEditingController();
  TextEditingController notes_date = TextEditingController();
  DBcontroller db = DBcontroller();
  final _key = GlobalKey<FormState>();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the desired page based on the selected index
    if (index == 0) {
      // Navigate to Notes page
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => HomePage(),
      )); // Replace '/notes' with the actual route name for your Notes page
    }
  }

  List<Map<String, dynamic>> notes = [];

  void _selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2030));

    if (_picked != null) {
      setState(() {
        notes_date.text = _picked.toString().split(' ')[0];
      });
    }
  }

  void addNotesf() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Notes'),
        content: Form(
          key: _key,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) return "must be fiiled";
                    return null;
                  },
                  decoration: InputDecoration(hintText: 'Notes name'),
                  controller: notes_name,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) return "must be fiiled";
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: 'Amount'),
                  controller: notes_amount,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: notes_date,
                  decoration: const InputDecoration(
                      filled: true,
                      prefixIcon: Icon(Icons.calendar_today),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan))),
                  readOnly: true,
                  onTap: () {
                    _selectDate();
                  },
                )
              ],
            ),
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              if (_key.currentState!.validate()) {
                _key.currentState!.save();
                db.insertNote(Notesmodel(
                    name: notes_name.text,
                    amount: int.parse(notes_amount.text),
                    dateTime: notes_date.text));
                Navigator.of(context).pop();
                notes_name.clear();
                notes_amount.clear();
                notes_date.clear();
              }
            },
            child: Text("Save"),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel"),
          )
        ],
      ),
    );
  }

  Future? loadnotes() async {
    final slist = await db.selectnotes();
    setState(() {
      notes = slist;
    });
  }

  Future? deletenotes(int id) {
    setState(() async {
      await db.deleteNote(id);
    });
  }

  int _totalAmount = 0; // Store the total amount

  Future<void> _refreshTotal() async {
    final dbController = DBcontroller();
    _totalAmount = await dbController.getTotalAmount();
    setState(() {}); // Rebuild the widget to display the updated total
  }

  @override
  void initState() {
    super.initState();
    _refreshTotal(); // Fetch the total amount on initialization
  }

  Widget viewnotes() {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(
              notes[index]['name'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(notes[index]['dateTime']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('ريال' + notes[index]['amount'].toString()),
                IconButton(
                  onPressed: () {
                    deletenotes(notes[index]['id']);
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('total Needs : ' + _totalAmount.toString()),
        actions: [
          IconButton(onPressed: _refreshTotal, icon: Icon(Icons.refresh))
        ],
      ),
      backgroundColor: Color(0xffDDDCDD),
      body: Center(
        child: FutureBuilder(
          future: loadnotes(),
          builder: (context, snapshot) {
            return viewnotes();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan,
        onPressed: addNotesf,
        child: Icon(Icons.note_add_sharp),
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
    );
  }
}
