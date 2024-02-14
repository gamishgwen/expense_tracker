import 'package:flutter/material.dart';

enum Category{
  leisure,
books,
  food,
  travel
}
IconData icon(Category category){
  if(category==Category.leisure){
    return Icons.beach_access;
  }
  else if(category==Category.books){
    return Icons.library_books;
  }
  else if(category==Category.food){
    return Icons.emoji_food_beverage;
  }
  else if(category==Category.travel){
    return Icons.shopping_bag_outlined;
  }
  else throw Exception();
}

