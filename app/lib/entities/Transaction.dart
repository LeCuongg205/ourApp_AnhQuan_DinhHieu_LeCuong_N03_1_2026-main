

class Transaction {
  int _id;
  String _description;
  double _amount;
  DateTime _date;

  
  Transaction(this._id, this._description, this._amount, this._date);

  // Getter & Setter cho id
  int get transactionId => _id;
  set transactionId(int id) => _id = id;

  // Getter & Setter cho description
  String get transactionDescription => _description;
  set transactionDescription(String description) => _description = description;

  // Getter & Setter cho amount
  double get transactionAmount => _amount;
  set transactionAmount(double amount) => _amount = amount;

  // Getter & Setter cho date
  DateTime get transactionDate => _date;
  set transactionDate(DateTime date) => _date = date;

  void showInfo() {
    print("ID: $_id, Mô tả: $_description, Số tiền: $_amount, Ngày: $_date");
  }
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'description': _description,
      'amount': _amount,
      'date': _date.toIso8601String(),
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      json['id'],
      json['description'],
      json['amount'],
      DateTime.parse(json['date']),
    );
  }
}

