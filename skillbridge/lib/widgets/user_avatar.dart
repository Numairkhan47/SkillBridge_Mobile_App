import 'package:flutter/material.dart';

/// Renders a colored circular avatar with the user's initials.
///
/// The app deliberately avoids depending on network images for user
/// avatars (keeping the demo fully functional offline); this widget
/// gives every user a consistent, recognisable placeholder instead.
class UserAvatar extends StatelessWidget {
  final String name;
  final String colorHex;
  final double radius;

  const UserAvatar({
    super.key,
    required this.name,
    required this.colorHex,
    this.radius = 24,
  });

  Color get _color {
    final hex = colorHex.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: _color,
      child: Text(
        _initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: radius * 0.7,
        ),
      ),
    );
  }
}
