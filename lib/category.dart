import 'package:flutter/material.dart';

enum Category {
  food,
  travel,
  entertainment,
  work,
}

Icon getCategoryIcon(Category category) {
  if(category==Category.food) {
    return const Icon(Icons.fastfood);
  } else if(category==Category.travel)
    return const Icon((Icons.flight_takeoff_outlined));
  else if(category==Category.entertainment)
    return const Icon(Icons.movie_filter);
  else if(category==Category.work)
    return const Icon(Icons.work_outline);

  throw Exception('Category not found');
}