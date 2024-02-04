import 'package:expense_tracker/expense_page.dart';
import 'package:flutter/material.dart';

import 'category.dart';
import 'expense.dart';

List<Expense> expenses = [];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.purple,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Expense Tracker',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () async {
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ExpensePage()));
                      setState(() {

                      });
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Graph(),
            for (int i = 0; i < expenses.length; i++)
              ExpenseWidget(x: expenses[i])
          ],
        ),
      ),
    );
  }
}

class Graph extends StatelessWidget {
  const Graph({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.white, Colors.purpleAccent.shade100],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)),
      height: 300,
      child: Row(
        children: [
          for (int i = 0; i < Category.values.length; i++)
            CategoryGraph(category: Category.values[i]),
        ],
      ),
    );
  }
}

class CategoryGraph extends StatelessWidget {
  const CategoryGraph({super.key, required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    double totalExpense = 0;
    double categoryExpense = 0;
    for (int i = 0; i < expenses.length; i++) {
      final expense = expenses[i];
      totalExpense = totalExpense + expense.amount;
      if (expense.category == category) {
        categoryExpense = categoryExpense + expense.amount;
      }
    }

    double categoryPercentage = (categoryExpense / totalExpense) * 100;
    final containerHeight = (categoryPercentage * 220) / 100;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: containerHeight.isNaN ? 0 : containerHeight,
            width: 66,
            decoration: const BoxDecoration(
                color: Colors.purpleAccent,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
          ),
          const SizedBox(height: 16),
          getCategoryIcon(category),
        ],
      ),
    );
  }
}

class ExpenseWidget extends StatefulWidget {
  final Expense x;
  const ExpenseWidget({super.key, required this.x});

  @override
  State<ExpenseWidget> createState() => _ExpenseWidgetState();
}

class _ExpenseWidgetState extends State<ExpenseWidget> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.x),
      background: ColoredBox(color: Colors.red, child: Center(child: Text('Delete',style: TextStyle(fontSize: 40, color: Colors.white)))),
      onDismissed: (direction) {
expenses.remove(widget.x);
      },
      child: GestureDetector(
        onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute(builder: (context) => ExpensePage(expense: widget.x),));
          setState(() {

          });
        },
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.purpleAccent.shade100),
          child: Column(
            children: [
              Row(
                children: [
                  Text(widget.x.title),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.x.amount.toString()),
                  Row(
                    children: [
                      getCategoryIcon(widget.x.category),
                      Text('${widget.x.date.day}-${widget.x.date.month}-${widget.x.date.year}'),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
