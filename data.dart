class Transactions {
  final int? id;
  final String name;
  final num cost;
  final String type;
  final String date;
  final String month;
  final String year;

  Transactions({
    this.id,
    required this.name,
    required this.cost,
    required this.type,
    required this.date,
    required this.month,
    required this.year,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cost': cost,
      'type': type,
      'date': date,
      'month': month,
      'year': year,
    };
  }

  @override
  String toString() {
    return 'Transactions{id: $id, name: $name, cost: $cost, type: $type, date: $date,month: $month}';
  }
}
