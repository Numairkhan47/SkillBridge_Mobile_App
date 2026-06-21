import 'package:flutter/material.dart';
import '../models/skill_model.dart';
import '../utils/app_colors.dart';
import '../utils/icon_helper.dart';
import 'rating_stars.dart';

/// Card widget representing one skill/freelance listing in a scrollable
/// list. Tapping it navigates to the detail screen via [onTap].
class SkillCard extends StatelessWidget {
  final SkillModel skill;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteTap;
  final bool isFavorite;

  const SkillCard({
    super.key,
    required this.skill,
    required this.onTap,
    this.onFavoriteTap,
    this.isFavorite = false,
  });

  Color get _typeColor {
    switch (skill.type) {
      case ExchangeType.paidGig:
        return AppColors.accentOrange;
      case ExchangeType.skillSwap:
        return AppColors.secondary;
      case ExchangeType.free:
        return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(categoryIcon(skill.category), color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          skill.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            RatingStars(rating: skill.rating, size: 14),
                            const SizedBox(width: 6),
                            Text(
                              '(${skill.completedCount})',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).textTheme.bodySmall?.color,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (onFavoriteTap != null)
                    IconButton(
                      onPressed: onFavoriteTap,
                      icon: Icon(
                        isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isFavorite ? Colors.redAccent : Colors.grey,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                skill.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.75),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _typeColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      skill.type.label,
                      style: TextStyle(
                        color: _typeColor,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.location_on_outlined,
                            size: 14, color: Theme.of(context).textTheme.bodySmall?.color),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            skill.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (skill.type == ExchangeType.paidGig && skill.price != null)
                    Text(
                      'Rs. ${skill.price!.toStringAsFixed(0)}',
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
