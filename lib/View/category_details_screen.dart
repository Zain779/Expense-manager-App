// import 'dart:js';

import 'package:expanse_manager/Widgets/confirm_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../Controller/db_helper.dart';
import '../Utils/colors.dart';

class CategoryDetailsScreen extends StatefulWidget {
  final String category;

  CategoryDetailsScreen({required this.category});

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  DbHelper dbHelper = DbHelper();

  int totalBalance = 0;

  int totalIncome = 0;

  int totalExpense = 0;
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
                                  return incomeTile(
                                      dataAtIndex['amount'],
                                      dataAtIndex['note'],
                                      dataAtIndex['date'],
                                      index);
                                } else if (dataAtIndex['type'] == 'Expense' &&
                                    dataAtIndex['selectOption'] ==
                                        widget.category) {
                                  return expenseTile(
                                    dataAtIndex['amount'],
                                    dataAtIndex['note'],
                                    dataAtIndex['date'],
                                    index,
                                  );
                                } else {
                                  return SizedBox();
                                }
                              }),
                        )
                      ],
                    );
                  } else {
                    return Center(
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

  Widget expenseTile(
    int value,
    String note,
    DateTime date,
    int index,
  ) {
    return Slidable(
      startActionPane: ActionPane(motion: BehindMotion(), children: [
        SlidableAction(
          onPressed: (context) async {
            bool? answer = await showConfirmDialog(
                context, 'warning', 'Do you want to delete this record');
            if (answer != null && answer) {
              dbHelper.deleteData(index);
              setState(() {});
            }
          },
          icon: Icons.delete,
          backgroundColor: Colors.red,
        )
      ]),
      child: InkWell(
        onLongPress: () async {
          bool? answer = await showConfirmDialog(
              context, 'warning', 'Do you want to delete this record');
          if (answer != null && answer) {
            dbHelper.deleteData(index);
            setState(() {});
          }
        },
        child: Container(
          padding: const EdgeInsets.all(18.0),
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Color(0xffced4eb),
            borderRadius: BorderRadius.circular(
              8.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.arrow_circle_up_outlined,
                            size: 28.0,
                            color: Colors.red[700],
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Column(
                            children: [
                              Text(
                                "Expense",
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  '${date.day} ${months[date.month - 1]}',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      //
                      // Padding(
                      //   padding: const EdgeInsets.all(6.0),
                      //   child: Text(
                      //     "${date.day} ${[date.month - 1]} ",
                      //     style: TextStyle(
                      //       color: Colors.grey[800],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "- $value",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      //
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          note,
                          style: TextStyle(
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget incomeTile(
    int value,
    String note,
    DateTime date,
    int index,
  ) {
    return Slidable(
      startActionPane: ActionPane(motion: BehindMotion(), children: [
        SlidableAction(
          onPressed: (context) async {
            bool? answer = await showConfirmDialog(
                context, 'warning', 'Do you want to delete this record');
            if (answer != null && answer) {
              dbHelper.deleteData(index);
              setState(() {});
            }
          },
          icon: Icons.delete,
          backgroundColor: Colors.red,
        )
      ]),
      child: InkWell(
        onLongPress: () async {
          bool? answer = await showConfirmDialog(
              context, 'warning', 'Do you want to delete this record');
          if (answer != null && answer) {
            dbHelper.deleteData(index);
            setState(() {});
          }
        },
        child: Container(
          padding: const EdgeInsets.all(18.0),
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Color(0xffced4eb),
            borderRadius: BorderRadius.circular(
              8.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_circle_down_outlined,
                        size: 28.0,
                        color: Colors.green[700],
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Column(
                        children: [
                          Text(
                            "Credit",
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              '${date.day} ${months[date.month - 1]}',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  //
                  // Padding(
                  //   padding: const EdgeInsets.all(6.0),
                  //   child: Text(
                  //     "${date.day} ${[date.month - 1]} ",
                  //     style: TextStyle(
                  //       color: Colors.grey[800],
                  //     ),
                  //   ),
                  // ),
                  //
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "+ $value",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  //
                  //
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      note,
                      style: TextStyle(
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
