import 'package:expense_tracker/category.dart';
import 'package:expense_tracker/drop_down_expense_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'expense.dart';

List<Expense> allExpense = [];
double totalExpense() {
  return allExpense.fold(0, (previousValue, element) => previousValue + element.amount);

  double t = 0;
  for (int i = 0; i < allExpense.length; i++) {
    t = t + allExpense[i].amount;
  }
  return t;
}

double categoryExpense(Category category) {
  double ct = 0;
  for (int i = 0; i < allExpense.length; i++) {
    if (allExpense[i].category == category) {
      ct = ct + allExpense[i].amount;
    }
  }
  return ct;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return const ExpensePage();
                  },
                );
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Column(
        children: [
          Chart(),
          Expanded(
              child: ListView.builder(
            itemCount: allExpense.length,
            itemBuilder: (context, index) {
              return ExpenseCard(expense: allExpense[index]);
            },
          )),
          // ...allExpense.map((e) => ExpenseCard(expense: e)).toList()
        ],
      ),
    );
  }
}

class ExpenseCard extends StatelessWidget {
  final Expense expense;

  const ExpenseCard({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) async {
        bool isDeleted = true;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(
          children: [
            const Text('Deleted'),
            const Spacer(),
            TextButton(
                onPressed: () {
                  isDeleted = false;
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                child: const Text('undo'))
          ],
        )));
        await Future.delayed(const Duration(seconds: 4));
        return Future.value(isDeleted);
      },
      onDismissed: (direction) {
        allExpense.remove(expense);
      },
      background: const ColoredBox(
        color: Colors.red,
        child: Center(
            child: Text(
          'Delete',
          style: TextStyle(fontSize: 24),
        )),
      ),
      key: ValueKey(expense.date),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return ExpensePage(
                expense: expense,
              );
            },
          );
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(expense.title),
                Row(
                  children: [
                    Text('\$${expense.amount}'),
                    const Spacer(),
                    Icon(icon(expense.category)),
                    Text(DateFormat('dd/MM/yyyy').format(expense.date))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Chart extends StatelessWidget {
  const Chart({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (int i = 0; i < Category.values.length; i++)
            ContainerChart(category: Category.values[i])
        ],
      ),
    );
  }
}

class ContainerChart extends StatelessWidget {
  final Category category;
  const ContainerChart({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    double containerHeight = (categoryExpense(category) / totalExpense()) * 100;
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          Container(
              width: 60,
              height: containerHeight.isNaN ? 0 : containerHeight,
              color: Colors.cyan),
          SizedBox(height: 20),
          Icon(icon(category))
        ],
      ),
    );
  }
}
