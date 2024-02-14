import 'package:expense_tracker/expense.dart';
import 'package:expense_tracker/home.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'category.dart';

class ExpensePage extends StatefulWidget {
  final Expense? expense;
  const ExpensePage({super.key, this.expense});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  late TextEditingController titleController =
      TextEditingController(text: widget.expense?.title);
  late TextEditingController amountController =
      TextEditingController(text: widget.expense?.amount.toString());
  late Category selectedType = widget.expense?.category ?? Category.leisure;
  late DateTime? selectedDate = widget.expense?.date;

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(keyboardType: TextInputType.text,
            controller: titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(keyboardType: TextInputType.number,
                  controller: amountController,
                  decoration: InputDecoration(labelText: 'Amount'),
                ),
              ),
              Text(selectedDate == null
                  ? 'no date selected'
                  : DateFormat('dd/MM/yyyy').format(selectedDate!)),
              IconButton(
                  onPressed: () async {
                    DateTime? updatedDate = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2024),
                        lastDate: DateTime.now(),
                        currentDate: selectedDate);
                    if (updatedDate != null) {
                      setState(() {
                        selectedDate = updatedDate;
                      });
                    }
                  },
                  icon: Icon(Icons.date_range))
            ],
          ),
          Row(
            children: [
              DropdownButton(
                value: selectedType,
                items: Category.values.map((e) {
                  return DropdownMenuItem(
                    child: Text(e.name),
                    value: e,
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedType = value!;
                  });
                },
              ),
              Spacer(),
              TextButton(onPressed: () {
                Navigator.of(context).pop();
              }, child: Text('Cancel')),
              ElevatedButton(
                  onPressed: () {
                    if (selectedDate != null) {
                      Expense ex = Expense(
                          titleController.text.trim(),
                          double.tryParse(amountController.text) ?? 0,
                          selectedType,
                          selectedDate!);
                      allExpense.add(ex);
                      allExpense.remove(widget.expense);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('save'))
            ],
          )
        ],
      ),
    );
  }
}
