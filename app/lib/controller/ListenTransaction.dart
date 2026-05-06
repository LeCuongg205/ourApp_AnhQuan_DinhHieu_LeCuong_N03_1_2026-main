import 'dart:io';
import '../entities/Transaction.dart';
import 'dart:convert';
class ListTransaction {
  
  List<Transaction> listTransaction = [];
  //CREATE:

  void inputTransactions() {
    stdout.write("Nhập số lượng Transaction: ");
    int n = int.parse(stdin.readLineSync()!);

    for (int i = 0; i < n; i++) {
      stdout.write("Nhập ID: ");
      int id = int.parse(stdin.readLineSync()!);

      stdout.write("Nhập mô tả: ");
      String description = stdin.readLineSync()!;

      stdout.write("Nhập số tiền: ");
      double amount = double.parse(stdin.readLineSync()!);

      stdout.write("Nhập ngày (yyyy-mm-dd): ");
      String dateInput = stdin.readLineSync()!;
      DateTime date = DateTime.parse(dateInput);

      var t = Transaction(id, description, amount, date);
      listTransaction.add(t);
      print("Đã thêm Transaction $id");
    }
  }

  // READ: 
  void readAll() {
    print("Danh sách Transaction:");
    for (var t in listTransaction) {
      t.showInfo();
    }
  }

  // UPDATE: 
  void edit(int id) {
    for (var t in listTransaction) {
      if (t.transactionId == id) {
        stdout.write("Nhập mô tả mới: ");
        String newDescription = stdin.readLineSync()!;
        t.transactionDescription = newDescription;

        stdout.write("Nhập số tiền mới: ");
        double newAmount = double.parse(stdin.readLineSync()!);
        t.transactionAmount = newAmount;

        stdout.write("Nhập ngày mới (yyyy-mm-dd): ");
        String dateInput = stdin.readLineSync()!;
        DateTime newDate = DateTime.parse(dateInput);
        t.transactionDate = newDate;

        print("Đã sửa bản ghi có id $id:");
        t.showInfo();
        return;
      }
    }
    print("Không tìm thấy Transaction có id $id");
  }
  String toJson() {
    return jsonEncode(listTransaction.map((t) => t.toJson()).toList());
  }
  void showAll() {
    print("Danh sách Transaction:");
    for (var t in listTransaction) {
      t.showInfo();
  }
}
  // Nhập danh sách từ JSON
  void fromJson(String jsonString) {
    List<dynamic> data = jsonDecode(jsonString);
    listTransaction = data.map((e) => Transaction.fromJson(e)).toList();
  }
}
