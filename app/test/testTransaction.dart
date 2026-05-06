import 'package:flutter_test/flutter_test.dart';
import 'package:app/entities/Transaction.dart';
import 'package:app/controller/ListenTransaction.dart';

void main() {
  test('Thêm Transaction vào ListTransaction', () {
    final list = ListTransaction();
    final t = Transaction(1, "Mua sách", 120000, DateTime.now());

    // Thêm trực tiếp vào listTransaction vì chưa có method create
    list.listTransaction.add(t);

    expect(list.listTransaction.length, 1);
    // Dùng đúng getter transactionDescription
    expect(list.listTransaction.first.transactionDescription, "Mua sách");
  });

  test('Xuất và nhập JSON', () {
    final list = ListTransaction();
    list.listTransaction.add(Transaction(2, "Ăn trưa", 50000, DateTime.now()));

    final jsonData = list.toJson();
    final newList = ListTransaction();
    newList.fromJson(jsonData);

    expect(newList.listTransaction.length, 1);
    expect(newList.listTransaction.first.transactionDescription, "Ăn trưa");
  });
}
