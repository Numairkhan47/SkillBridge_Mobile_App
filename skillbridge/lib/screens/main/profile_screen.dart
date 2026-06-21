import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/skill_provider.dart';
import '../../utils/app_colors.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/skill_card.dart';
import '../../widgets/user_avatar.dart';
import '../edit_profile_screen.dart';
import '../settings_screen.dart';
import '../skill_detail_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final skillProvider = context.watch<SkillProvider>();
    final user = auth.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('Not logged in.')));
    }

    final myListings = skillProvider.skillsByUser(user.id);
    final favorites = user.favoriteListingIds
        .map((id) => skillProvider.byId(id))
        .where((s) => s != null)
        .map((s) => s!)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  UserAvatar(name: user.name, colorHex: user.avatarColorHex, radius: 36),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name,
                            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                user.location,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Joined ${DateFormat('MMM yyyy').format(user.joinedDate)}',
                          style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                    ),
                    child: const Text('Edit'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _statCard(context, '${myListings.length}', 'Listings'),
                  const SizedBox(width: 10),
                  _statCard(context, user.rating.toStringAsFixed(1), 'Rating'),
                  const SizedBox(width: 10),
                  _statCard(context, '${favorites.length}', 'Saved'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            if (user.bio.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Text(
                  user.bio,
                  style: TextStyle(
                      fontSize: 13.5,
                      height: 1.5,
                      color: Theme.of(context).textTheme.bodyMedium?.color),
                ),
              ),
            TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              tabs: const [
                Tab(text: 'My Listings'),
                Tab(text: 'Favorites'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  myListings.isEmpty
                      ? const EmptyState(
                          icon: Icons.list_alt_rounded,
                          title: 'No listings yet',
                          subtitle: 'Tap the + tab to post your first skill or gig.',
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(20),
                          itemCount: myListings.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, i) {
                            final skill = myListings[i];
                            return SkillCard(
                              skill: skill,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => SkillDetailScreen(skillId: skill.id),
                                ),
                              ),
                            );
                          },
                        ),
                  favorites.isEmpty
                      ? const EmptyState(
                          icon: Icons.favorite_border_rounded,
                          title: 'No favorites yet',
                          subtitle: 'Tap the heart icon on any listing to save it here.',
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(20),
                          itemCount: favorites.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, i) {
                            final skill = favorites[i];
                            return SkillCard(
                              skill: skill,
                              isFavorite: true,
                              onFavoriteTap: () => auth.toggleFavorite(skill.id),
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => SkillDetailScreen(skillId: skill.id),
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(BuildContext context, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
