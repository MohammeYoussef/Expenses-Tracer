class Notesmodel {
  int? id;
  String? name;
  int? amount;
  String? dateTime;

  Notesmodel({this.id, this.name, this.amount, this.dateTime});

  Map<String, dynamic> tomap() {
    return {'id': id, 'name': name, 'amount': amount, 'dateTime': dateTime};
  }
}
