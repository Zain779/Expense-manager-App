// import 'dart:js';

import 'package:expanse_manager/Widgets/confirm_dialogue.dart';
import 'package:expanse_manager/Widgets/expense_tile.dart';
import 'package:expanse_manager/Widgets/income_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../Controller/db_helper.dart';
import '../Utils/colors.dart';

class CategoryDetailsScreen extends StatefulWidget {
  String? category = '';

  CategoryDetailsScreen({required this.category});

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  DbHelper dbHelper = DbHelper();
  // final editController = TextEditingController();
  final titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  int totalBalance = 0;

  int totalIncome = 0;

  int totalExpense = 0;

  getTotalBalance(Map entireData) {
    totalBalance = 0;
    totalIncome = 0;
    totalExpense = 0;
    entireData.forEach((key, value) {
      if (value['type'] == 'Income') {
        totalBalance += (value['amount'] as int);
        totalIncome += (value['amount'] as int);
      } else {
        totalBalance -= (value['amount'] as int);
        totalExpense += (value['amount'] as int);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category}'),
        backgroundColor: ThemeColor1,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<Map>(
                future: dbHelper.fetch(),
                builder: (context, snapshot) {
                  // print(snapshot.data);
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        "Oopssss !!! There is some error !",
                        style: TextStyle(
                          fontSize: 24.0,
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          "You haven't added Any Data !",
                          style: TextStyle(
                            fontSize: 24.0,
                          ),
                        ),
                      );
                    }
                    getTotalBalance(snapshot.data!);
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                              // physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                Map dataAtIndex = snapshot.data![index];
                                if (dataAtIndex['type'] == 'Income' &&
                                    dataAtIndex['selectOption'] ==
                                        widget.category) {
                                  return IncomeTile(
                                    amount: dataAtIndex['amount'],
                                    note: dataAtIndex['note'],
                                    date: dataAtIndex['date'],
                                    index: index,
                                  );
                                } else if (dataAtIndex['type'] == 'Expense' &&
                                    dataAtIndex['selectOption'] ==
                                        widget.category) {
                                  return ExpenseTile(
                                      amount: dataAtIndex['amount'],
                                      note: dataAtIndex['note'],
                                      date: dataAtIndex['date'],
                                      index: index);
                                } else {
                                  return const SizedBox();
                                }
                              }),
                        )
                      ],
                    );
                  } else {
                    return const Center(
                      child: Text(
                        "Oopssss !!! There is some error !",
                        style: TextStyle(
                          fontSize: 24.0,
                        ),
                      ),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}
