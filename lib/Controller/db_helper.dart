import 'package:hive/hive.dart';

class DbHelper {
  late Box box;

  DbHelper() {
    openBox();
  }
  openBox() {
    box = Hive.box('money');
  }

  Future addData(int amount, DateTime date, String note, String type,
      String selectedOption) async {
    var value = {
      'amount': amount,
      'date': date,
      'type': type,
      'note': note,
      'selectOption': selectedOption
    };
    box.add(value);
  }

  Future deleteData(int index) async {
    await box.deleteAt(index);
  }

  Future<Map> fetch() async {
    if (box.values.isEmpty) {
      return Future.value({});
    } else {
      return Future.value(box.toMap());
    }
  }
}