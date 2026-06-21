import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/skill_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/skill_card.dart';
import '../skill_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final skillProvider = context.watch<SkillProvider>();
    final results = skillProvider.filteredSkills;

    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => context.read<SkillProvider>().setSearchQuery(value),
                decoration: InputDecoration(
                  hintText: 'Search skills, e.g. "guitar" or "tutor"',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _searchController.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () {
                            _searchController.clear();
                            context.read<SkillProvider>().setSearchQuery('');
                            setState(() {});
                          },
                        ),
                ),
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
              ),
            ),
            SizedBox(
              height: 42,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: AppConstants.categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final cat = AppConstants.categories[i];
                  return CategoryChip(
                    label: cat,
                    selected: skillProvider.selectedCategory == cat,
                    onTap: () => context.read<SkillProvider>().setCategory(cat),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: results.isEmpty
                  ? const EmptyState(
                      icon: Icons.travel_explore_rounded,
                      title: 'No matches yet',
                      subtitle: 'Try searching a different keyword or category.',
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      itemCount: results.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final skill = results[i];
                        return SkillCard(
                          skill: skill,
                          isFavorite: auth.isFavorite(skill.id),
                          onFavoriteTap: () => auth.toggleFavorite(skill.id),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => SkillDetailScreen(skillId: skill.id),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
