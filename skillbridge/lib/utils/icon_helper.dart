import 'package:flutter/material.dart';

/// Maps a skill category string to a representative [IconData].
/// Centralising this avoids repeating long switch statements in every
/// widget that needs to show a category icon.
IconData categoryIcon(String category) {
  switch (category) {
    case 'Home Repair':
      return Icons.build_rounded;
    case 'Tutoring':
      return Icons.school_rounded;
    case 'Design & Art':
      return Icons.palette_rounded;
    case 'Tech & Coding':
      return Icons.code_rounded;
    case 'Music':
      return Icons.music_note_rounded;
    case 'Fitness':
      return Icons.fitness_center_rounded;
    case 'Cooking':
      return Icons.restaurant_rounded;
    case 'Photography':
      return Icons.camera_alt_rounded;
    case 'Languages':
      return Icons.translate_rounded;
    case 'Gardening':
      return Icons.eco_rounded;
    case 'Events':
      return Icons.celebration_rounded;
    default:
      return Icons.apps_rounded;
  }
}
