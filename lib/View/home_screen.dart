import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import '../Controller/db_helper.dart';
import '../Model/transaction.dart';
import '../Services/session_manager.dart';
import 'add_transaction_screen.dart';
import 'category_details_screen.dart';
import '../Utils/colors.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('User');
  TextEditingController mcategoryController = TextEditingController();
  List<String> mcategories = [];

  @override
  void initState() {
    super.initState();
    mloadCategories();
    // box = Hive.box('money');
    // fetch();
  }

  mloadCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      mcategories = prefs.getStringList('categories') ?? [];
    });
  }

  msaveCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('categories', mcategories);
  }

  _addCategory() {
    String newCategory = mcategoryController.text.trim();
    if (newCategory.isNotEmpty && !mcategories.contains(newCategory)) {
      setState(() {
        mcategories.add(newCategory);
        mcategoryController.clear();
        msaveCategories();
      });
    }
  }

  // late Box box;

  // Future<List<TransactionModel>> fetch() async {
  //   if (box.values.isEmpty) {
  //     return Future.value([]);
  //   } else {
  //     List<TransactionModel> items = [];
  //     box.toMap().values.forEach((element) {
  //       items.add(TransactionModel(
  //           element['amount'] as int,
  //           element['date'] as DateTime,
  //           element['note'],
  //           element['type'],
  //           element['selectedOption']));
  //     });
  //     return items;
  //   }
  // }

  _openCategoryDetailsScreen(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryDetailsScreen(category: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DbHelper dbHelper = DbHelper();
    int totalBalance = 0;
    int totalIncome = 0;
    int totalExpense = 0;
    getTotalBalance(
        // List<TransactionModel> entireData
        Map entireData) {
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

      // for (TransactionModel data in entireData) {
      //   if(data.date.month== today.month){}
      // }
    }

    int _currentIndex = 0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        backgroundColor: ThemeColor2,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) =>
                      AddTransactionScreen(myCategory: mcategories)))
              .whenComplete(() {
            setState(() {});
          });
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                child: Image.asset(
                  'assets/designs/images/rectangle-9-YCZ.png',
                  height: MediaQuery.of(context).size.height * .42,
                  width: MediaQuery.of(context).size.width * 1,
                ),
              ),
              Container(
                  child: Row(
                children: [
                  Image.asset(
                    'assets/designs/images/ellipse-8.png',
                    height: MediaQuery.of(context).size.height * .3,
                    width: MediaQuery.of(context).size.width * .3,
                  ),
                  Image.asset(
                    'assets/designs/images/ellipse-7.png',
                    height: MediaQuery.of(context).size.height * .2,
                    width: MediaQuery.of(context).size.width * .2,
                  ),
                  Image.asset(
                    'assets/designs/images/ellipse-7.png',
                    height: MediaQuery.of(context).size.height * .2,
                    width: MediaQuery.of(context).size.width * .2,
                  ),
                ],
              )),
              Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .06,
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.08),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Greeting,',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 20,
                                        color: white),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        .01,
                                  ),
                                  StreamBuilder(
                                      stream: ref
                                          .child(SessionController()
                                              .userID
                                              .toString())
                                          .onValue,
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (!snapshot.hasData) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else if (snapshot.hasData) {
                                          Map<dynamic, dynamic> map =
                                              snapshot.data.snapshot.value;
                                          return Text(
                                            map['username'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                                color: white),
                                          );
                                        } else {
                                          return Center(
                                              child: Text(
                                            'Something Went Wrong',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                          ));
                                        }
                                      }),
                                ],
                              ),
                              Container(
                                  height:
                                      MediaQuery.of(context).size.height * .06,
                                  width:
                                      MediaQuery.of(context).size.width * .09,
                                  decoration: BoxDecoration(
                                    color: ThemeColor2,
                                    borderRadius: BorderRadius.circular(11),
                                  ),
                                  child: Center(
                                      child: Icon(
                                    Icons.notification_add_outlined,
                                    color: white,
                                  )))
                            ],
                          )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .08,
                      ),
                      Center(
                        child: FutureBuilder<Map>
                            // <List<TransactionModel>>
                            (
                            future: dbHelper.fetch(),
                            // fetch(),
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
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .9,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .25,
                                        decoration: BoxDecoration(
                                            color: ThemeColor1,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .023),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .02,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(
                                                        'Total Balance ^',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 20,
                                                            color: white),
                                                      ),
                                                      Text(
                                                        "$totalBalance",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 23,
                                                            color: white),
                                                      ),
                                                    ],
                                                  ),
                                                  Icon(
                                                    Icons.more_horiz_outlined,
                                                    color: white,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .01,
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .02,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  cardIncome(
                                                      totalIncome.toString()),
                                                  cardExpense(
                                                      totalExpense.toString()),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )),
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
                    ]),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller:
                  // dataSingleton.mcategoryController,
                  mcategoryController,
              decoration: const InputDecoration(
                labelText: 'Add Category',
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: ThemeColor1, onPrimary: white),
            onPressed:
                // dataSingleton.maddCategory(),
                _addCategory,
            child: const Text('Add'),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  childAspectRatio: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemCount: //dataSingleton.mcategories.length,
                  mcategories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Container(
                      decoration: BoxDecoration(color: ThemeColor1),
                      child: Center(
                          child: Text(
                        // dataSingleton.mcategories[index],
                        mcategories[index],
                        style: TextStyle(color: white),
                      ))),
                  onTap: () => _openCategoryDetailsScreen(
                      // dataSingleton.mcategories[index],
                      mcategories[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget cardIncome(String value) {
  return Row(
    children: [
      Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(
            20.0,
          ),
        ),
        padding: const EdgeInsets.all(
          6.0,
        ),
        child: Icon(
          Icons.arrow_downward,
          size: 28.0,
          color: Colors.green[700],
        ),
        margin: const EdgeInsets.only(
          right: 8.0,
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Income",
            style: TextStyle(
              fontSize: 14.0,
              color: white,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
              color: white,
            ),
          ),
        ],
      ),
    ],
  );
}

Widget cardExpense(String value) {
  return Row(
    children: [
      Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(
            20.0,
          ),
        ),
        padding: EdgeInsets.all(
          6.0,
        ),
        child: Icon(
          Icons.arrow_upward,
          size: 28.0,
          color: Colors.red[700],
        ),
        margin: EdgeInsets.only(
          right: 8.0,
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Expense",
            style: TextStyle(
              fontSize: 14.0,
              color: white,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
              color: white,
            ),
          ),
        ],
      ),
    ],
  );
}

Widget expenseTile(
  int value,
  String note,
) {
  return InkWell(
    child: Container(
      padding: const EdgeInsets.all(18.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: white,
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
                      Text(
                        "Expense",
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
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
                        color: white,
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
  );
}

Widget incomeTile(
  int value,
  String note,
) {
  return InkWell(
    child: Container(
      padding: const EdgeInsets.all(18.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: white,
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
                  Text(
                    "Credit",
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
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
                    color: white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}