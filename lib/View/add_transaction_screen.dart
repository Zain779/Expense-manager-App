import 'package:expanse_manager/Utils/colors.dart';
import 'package:expanse_manager/Utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Controller/db_helper.dart';
import '../Services/session_manager.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({Key? key, required this.myCategory})
      : super(key: key);
  final List<String> myCategory;

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('User');
  int? amount;

  String note = 'Some Expense';

  String type = 'income';

  DateTime selectDate = DateTime.now();

  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  // Initial Selected Value
  String? selectedOption;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectDate,
        firstDate: DateTime(2020, 12),
        lastDate: DateTime(2100, 01));
    if (picked != null && picked != selectDate) {
      setState(() {
        selectDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * .04),
              Text(
                'Add Transaction',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: ThemeColor1),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .04),
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: ThemeColor1,
                    ),
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.attach_money,
                      color: white,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: '0',
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 24),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        try {
                          amount = int.parse(value);
                        } catch (e) {
                          e.toString();
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .02),
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: ThemeColor1,
                    ),
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.note_add_sharp,
                      color: white,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Note Description',
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 24),
                      inputFormatters: [
                        FilteringTextInputFormatter.singleLineFormatter
                      ],
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        note = value;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .02),
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: ThemeColor1,
                    ),
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.moving_sharp,
                      color: white,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ChoiceChip(
                    label: Text(
                      'Income',
                      style: TextStyle(
                        color: type == 'Income' ? Colors.white : Colors.black,
                      ),
                    ),
                    selected: type == 'Income' ? true : false,
                    selectedColor: ThemeColor1,
                    onSelected: (value) {
                      setState(() {
                        type = 'Income';
                      });
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ChoiceChip(
                    label: Text(
                      'Expense',
                      style: TextStyle(
                        color: type == 'Expense' ? Colors.white : Colors.black,
                      ),
                    ),
                    selected: type == 'Expense' ? true : false,
                    selectedColor: ThemeColor1,
                    onSelected: (value) {
                      setState(() {
                        type = 'Expense';
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .02),
              TextButton(
                onPressed: () {
                  _selectDate(context);
                },
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: ThemeColor1,
                      ),
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.calendar_month,
                        color: white,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text('${selectDate.day} ${months[selectDate.month - 1]}'),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .02),
              DropdownButton(
                // Initial Value
                value: selectedOption,
                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),
                // Array list of items
                items: widget.myCategory.map((data) {
                  return DropdownMenuItem<String>(
                    value: data,
                    child: Text(data),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedOption = newValue;
                  });
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .02),
              SizedBox(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: ThemeColor1, onPrimary: white),
                      onPressed: () async {
                        if (amount != null &&
                            note.isNotEmpty &&
                            selectedOption != null) {
                          DbHelper dbHelper = DbHelper();
                          await dbHelper.addData(
                              amount!, selectDate, note, type, selectedOption!);
                          // try {
                          //   ref
                          //       .child(SessionController().userID.toString())
                          //       .update({
                          //     'amount': amount,
                          //     // 'selectdate': selectDate,
                          //     'note': note,
                          //     'type': type,
                          //     'selectoption': selectedOption
                          //   }).then((value) {
                          //     utils().toastMessage('Added');
                          //   }).onError((error, stackTrace) {
                          //     utils().toastMessage(error.toString());
                          //   });
                          // } catch (e) {
                          //   utils().toastMessage(e.toString());
                          // }
                          Navigator.pop(context);
                        } else {
                          utils().toastMessage('Not all fields provided');
                        }
                      },
                      child: const Text('Add'))),
            ],
          ),
        ));
  }
}
