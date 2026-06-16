import 'package:flutter/material.dart';

/// Liste de tous les noms d’icônes disponibles pour les catégories d’habitudes.
const List<String> availableIcons = [
  'work',
  'person',
  'shopping',
  'health',
  'book',
  'music',
  'movie',
  'restaurant',
  'home',
  'school',
  'sports',
  'bike',
  'pets',
  'brush',
  'palette',
  'star',
  'favorite',
  'settings',
  'notifications',
  'email',
  'phone',
  'map',
  'camera',
  'video',
  'game',
];

const Map<String, IconData> iconMap = {
  'work': Icons.work,
  'person': Icons.person,
  'shopping': Icons.shopping_bag,
  'health': Icons.health_and_safety,
  'book': Icons.book,
  'music': Icons.music_note,
  'movie': Icons.movie,
  'restaurant': Icons.restaurant,
  'home': Icons.home,
  'school': Icons.school,
  'sports': Icons.sports_soccer,
  'bike': Icons.directions_bike,
  'pets': Icons.pets,
  'brush': Icons.brush,
  'palette': Icons.palette,
  'star': Icons.star,
  'favorite': Icons.favorite,
  'settings': Icons.settings,
  'notifications': Icons.notifications,
  'email': Icons.email,
  'phone': Icons.phone,
  'map': Icons.map,
  'camera': Icons.camera_alt,
  'video': Icons.video_library,
  'game': Icons.sports_esports,
};

IconData getIconData(String? iconName) {
  return iconMap[iconName] ?? Icons.help_outline;
}