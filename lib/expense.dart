

import 'package:expense_tracker/category.dart';

class Expense{
  final String title;
  final double amount;
  final Category category;
  final DateTime date;

  Expense(this.title, this.amount, this.category, this.date);
}