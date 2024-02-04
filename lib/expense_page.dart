import 'package:flutter/material.dart';

import 'category.dart';
import 'expense.dart';
import 'home_page.dart';

class ExpensePage extends StatefulWidget {
  final Expense? expense;
  const ExpensePage({super.key, this.expense});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  late double amount = widget.expense?.amount ?? 0;
  late String name = widget.expense?.title ?? '';
  late DateTime selectedDate = widget.expense?.date ?? DateTime.now();
  late Category selectedCategory = widget.expense?.category ?? Category.food;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextFormField(
              initialValue: name,
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                name = value;
                print(name);
              },
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: amount.toString(),
                    decoration: InputDecoration(labelText: 'Amount'),
                    onChanged: (value) {
                      amount = double.parse(value);
                      print(amount);
                    },
                  ),
                ),
                TextButton.icon(
                    onPressed: () async {
                      DateTime? updatedDate = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2024),
                          lastDate: DateTime.now(),
                          initialDate: selectedDate);
                      if (updatedDate != null) {
                        setState(() {
                          selectedDate = updatedDate;
                        });
                      }
                    },
                    icon: const Icon(Icons.calendar_month_outlined),
                    label: Text(
                        '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton(
                  value: selectedCategory,
                  items: Category.values
                      .map((category) => DropdownMenuItem(
                            child: Text(category.name),
                            value: category,
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });

                    print(value);
                  },
                ),
                Row(
                  children: [
                    TextButton(onPressed: () {
                      Navigator.of(context).pop();
                    }, child: const Text('cancel')),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purpleAccent.shade100),
                        onPressed: () {
                          Expense newExpense=Expense(name, amount, selectedDate, selectedCategory);
                          expenses.remove(widget.expense);
                          expenses.add(newExpense);
                          Navigator.of(context).pop();
                        },
                        child: const Text('save expense'))
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
