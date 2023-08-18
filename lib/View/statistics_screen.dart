import 'package:expanse_manager/Utils/colors.dart';
import 'package:expanse_manager/View/home_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../Controller/db_helper.dart';
import '../Widgets/expense_tile.dart';
import '../Widgets/income_tile.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  DbHelper dbHelper = DbHelper();
  int totalBalance = 0;
  int totalIncome = 0;
  int totalExpense = 0;
  DateTime today = DateTime.now();
  List<FlSpot> dataSet = [];
  List<FlSpot> getPlotPoints(Map entiredata) {
    dataSet = [];
    entiredata.forEach((key, value) {
      if (value['type'] == 'Expense' &&
          (value['date'] as DateTime).month == today.month) {
        dataSet.add(FlSpot((value['date'] as DateTime).day.toDouble(),
            (value['amount'] as int).toDouble()));
      }
    });
    return dataSet;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .05,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: ThemeColor1,
                  )),
              Text('Statistics',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: ThemeColor1,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.download,
                    color: ThemeColor1,
                  ))
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .01,
          ),
          FutureBuilder<Map>(
              future: dbHelper.fetch(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: SizedBox()
                      // Text(
                      //   "Oopssss !!! There is some error !",
                      //   style: TextStyle(
                      //     fontSize: 24.0,
                      //   ),
                      // ),
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
                  getPlotPoints(snapshot.data!);
                  return dataSet.length < 2
                      ? Container(
                          padding: EdgeInsets.all(12),
                          height: 200,
                          child: Text('Not Enough values to render Chart'))
                      : Container(
                          // padding: EdgeInsets.all(4),
                          height: 270,
                          child: LineChart(LineChartData(
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                    curveSmoothness: 0.45,
                                    spots: getPlotPoints(snapshot.data!),
                                    barWidth: 4.5,
                                    color: ThemeColor1,
                                    isCurved: true,
                                    belowBarData: BarAreaData(
                                        show: true,
                                        color: ThemeColor2.withOpacity(0.6)))
                              ])),
                        );
                } else {
                  return const Center(child: SizedBox()
                      // Text(
                      //   "Oopssss !!! There is some error !",
                      //   style: TextStyle(
                      //     fontSize: 24.0,
                      //   ),
                      // ),
                      );
                }
              }),
          SizedBox(
            height: MediaQuery.of(context).size.height * .03,
          ),
          Row(
            children: [
              Text('Top Spendings',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: ThemeColor1,
                  )),
            ],
          ),
          Expanded(
            child: FutureBuilder<Map>(
                future: dbHelper.fetch(),
                builder: (context, snapshot) {
                  // print(snapshot.data);

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
                    // getTotalBalance(snapshot.data!);
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                              // physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                Map dataAtIndex = snapshot.data![index];
                                if (dataAtIndex['type'] == 'Expense') {
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
                    return const Center(child: SizedBox()
                        // Text(
                        //   "Oopssss !!! There is some error !",
                        //   style: TextStyle(
                        //     fontSize: 24.0,
                        //   ),
                        // ),
                        );
                  }
                }),
          ),
        ],
      ),
    ));
  }
}
