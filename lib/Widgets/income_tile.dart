import 'package:expanse_manager/Utils/colors.dart';
import 'package:expanse_manager/Widgets/show-edit-dialogue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../Controller/db_helper.dart';
import 'confirm_dialogue.dart';

class IncomeTile extends StatefulWidget {
  final int amount;
  final String note;
  final DateTime date;
  final int index;
  const IncomeTile({
    Key? key,
    required this.amount,
    required this.note,
    required this.date,
    required this.index,
  }) : super(key: key);

  @override
  State<IncomeTile> createState() => _IncomeTileState();
}

class _IncomeTileState extends State<IncomeTile> {
  @override
  Widget build(BuildContext context) {
    DbHelper dbHelper = DbHelper();
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
    return Slidable(
      startActionPane: ActionPane(motion: const BehindMotion(), children: [
        SlidableAction(
          onPressed: (context) async {
            bool? answer = await showConfirmDialog(
                context, 'warning', 'Do you want to delete this record');
            if (answer != null && answer) {
              dbHelper.deleteData(widget.index);
              setState(() {});
            }
          },
          icon: Icons.delete,
          backgroundColor: Colors.red,
        ),
        SlidableAction(
          onPressed: (context) async {
            showEditDialogue(context, widget.note, widget.index);
          },
          icon: Icons.edit,
          backgroundColor: Colors.blue,
        )
      ]),
      child: InkWell(
        onLongPress: () async {
          bool? answer = await showConfirmDialog(
              context, 'warning', 'Do you want to delete this record');
          if (answer != null && answer) {
            dbHelper.deleteData(widget.index);
            setState(() {});
          }
        },
        child: Container(
          padding: const EdgeInsets.all(14.0),
          margin: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: ThemeColor2.withOpacity(0.3),
            border: Border.all(color: ThemeColor1, width: 3.5),
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
                      const SizedBox(
                        width: 4.0,
                      ),
                      Column(
                        children: [
                          const Text(
                            "Credit",
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              '${widget.date.day} ${months[widget.date.month - 1]}',
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "+ ${widget.amount}",
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  //
                  //
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      widget.note,
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
