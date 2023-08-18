import 'package:flutter/material.dart';
import '../Controller/db_helper.dart';

Future<void> showEditDialogue(
  BuildContext context,
  String title,
  int index,
  // int amount
) async {
  DbHelper dbHelper = DbHelper();
  final titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  titleController.text = title;
  // amountController.text = amount;
  return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Edit Note',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                // TextFormField(
                //   controller: amountController,
                //   keyboardType: TextInputType.number,
                //   decoration: const InputDecoration(
                //     hintText: 'Edit amount',
                //     border: OutlineInputBorder(),
                //   ),
                // ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('cancel')),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  title = titleController.text.toString();
                  // amount = int.parse(amountController.text);
                  dbHelper.updateData(index, title
                      // amount
                      );
                },
                child: Text('update')),
          ],
        );
      });
}
