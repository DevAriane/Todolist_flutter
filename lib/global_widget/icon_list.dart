import 'package:flutter/material.dart';

const List<String> availableIconNames = [
  'work',
  'person',
  'shopping_bag',
  'fitness_center',
  'health_and_safety',
  'book',
  'music_note',
  'movie',
  'restaurant',
  'home',
  'school',
  'sports_soccer',
  'directions_bike',
  'pets',
  'brush',
  'palette',
];

IconData getIconDataFromName(String name) {
  switch (name) {
    case 'work':
      return Icons.work;
    case 'person':
      return Icons.person;
    case 'shopping_bag':
      return Icons.shopping_bag;
    case 'fitness_center':
      return Icons.fitness_center;
    case 'health_and_safety':
      return Icons.health_and_safety;
    case 'book':
      return Icons.book;
    case 'music_note':
      return Icons.music_note;
    case 'movie':
      return Icons.movie;
    case 'restaurant':
      return Icons.restaurant;
    case 'home':
      return Icons.home;
    case 'school':
      return Icons.school;
    case 'sports_soccer':
      return Icons.sports_soccer;
    case 'directions_bike':
      return Icons.directions_bike;
    case 'pets':
      return Icons.pets;
    case 'brush':
      return Icons.brush;
    case 'palette':
      return Icons.palette;
    default:
      return Icons.help; // fallback
  }
}
