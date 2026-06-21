import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/skill_model.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../providers/skill_provider.dart';
import '../utils/app_colors.dart';
import '../utils/icon_helper.dart';
import '../widgets/primary_button.dart';
import '../widgets/rating_stars.dart';
import '../widgets/user_avatar.dart';
import 'chat_screen.dart';

class SkillDetailScreen extends StatelessWidget {
  final String skillId;
  const SkillDetailScreen({super.key, required this.skillId});

  Color _typeColor(ExchangeType type) {
    switch (type) {
      case ExchangeType.paidGig:
        return AppColors.accentOrange;
      case ExchangeType.skillSwap:
        return AppColors.secondary;
      case ExchangeType.free:
        return AppColors.success;
    }
  }

  Future<void> _requestSkill(BuildContext context, SkillModel skill) async {
    final auth = context.read<AuthProvider>();
    if (skill.userId == auth.currentUser?.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This is your own listing.')),
      );
      return;
    }

    final convo = await context.read<ChatProvider>().startConversation(
          otherUserId: skill.userId,
          otherUserName: 'Provider', // resolved fully inside ChatScreen via convo data
          relatedSkillTitle: skill.title,
        );

    if (!context.mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ChatScreen(conversation: convo)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final skill = context.watch<SkillProvider>().byId(skillId);
    final auth = context.watch<AuthProvider>();

    if (skill == null) {
      return const Scaffold(body: Center(child: Text('Listing not found.')));
    }

    final isOwner = skill.userId == auth.currentUser?.id;
    final isFavorite = auth.isFavorite(skill.id);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    IconButton(
                      onPressed: () => auth.toggleFavorite(skill.id),
                      icon: Icon(
                        isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isFavorite ? Colors.redAccent : null,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'skill-icon-${skill.id}',
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(categoryIcon(skill.category), color: AppColors.primary, size: 36),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      skill.title,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        RatingStars(rating: skill.rating),
                        const SizedBox(width: 8),
                        Text(
                          '${skill.rating.toStringAsFixed(1)} \u00b7 ${skill.completedCount} completed',
                          style: TextStyle(
                              fontSize: 13, color: Theme.of(context).textTheme.bodySmall?.color),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Chip(
                          label: Text(skill.type.label),
                          backgroundColor: _typeColor(skill.type).withOpacity(0.12),
                          labelStyle: TextStyle(
                              color: _typeColor(skill.type), fontWeight: FontWeight.w700),
                          side: BorderSide.none,
                        ),
                        Chip(
                          label: Text(skill.category),
                          side: BorderSide.none,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text('About this listing',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text(
                      skill.description,
                      style: const TextStyle(fontSize: 14.5, height: 1.6),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoRow(context, Icons.location_on_outlined, 'Location', skill.location),
                          const Divider(height: 22),
                          _infoRow(
                            context,
                            Icons.calendar_today_outlined,
                            'Posted',
                            DateFormat('MMM d, yyyy').format(skill.postedDate),
                          ),
                          const Divider(height: 22),
                          if (skill.type == ExchangeType.paidGig)
                            _infoRow(
                              context,
                              Icons.payments_outlined,
                              'Price',
                              'Rs. ${skill.price?.toStringAsFixed(0) ?? '-'}',
                            )
                          else if (skill.type == ExchangeType.skillSwap)
                            _infoRow(
                              context,
                              Icons.swap_horiz_rounded,
                              'Wants in exchange',
                              skill.wantedInExchange ?? '-',
                            )
                          else
                            _infoRow(context, Icons.volunteer_activism_outlined, 'Cost',
                                'Free community help'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Posted by', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const UserAvatar(name: 'Skill Provider', colorHex: '#0984E3', radius: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('SkillBridge Member',
                                  style: TextStyle(fontWeight: FontWeight.w700)),
                              Text(
                                'Usually responds within a few hours',
                                style: TextStyle(
                                    fontSize: 12.5,
                                    color: Theme.of(context).textTheme.bodySmall?.color),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: PrimaryButton(
            label: isOwner ? 'This Is Your Listing' : 'Request This Skill',
            icon: isOwner ? Icons.info_outline : Icons.chat_bubble_outline_rounded,
            onPressed: isOwner ? null : () => _requestSkill(context, skill),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 10),
        Text(label, style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 13)),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
          ),
        ),
      ],
    );
  }
}
