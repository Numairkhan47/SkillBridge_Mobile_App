import 'package:flutter/material.dart';

/// Displays a 5-star rating row. Demonstrates building a small,
/// composable, stateless custom widget from scratch.
class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final Color color;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 16,
    this.color = const Color(0xFFFDCB6E),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final filled = index < rating.floor();
        final half = !filled && index < rating;
        IconData icon = Icons.star_border_rounded;
        if (filled) icon = Icons.star_rounded;
        if (half) icon = Icons.star_half_rounded;
        return Icon(icon, size: size, color: color);
      }),
    );
  }
}
