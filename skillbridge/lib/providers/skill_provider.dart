import 'package:flutter/material.dart';
import '../models/skill_model.dart';
import '../services/skill_repository.dart';

/// Manages the list of skill/freelance listings: loading, searching,
/// filtering by category, and creating new listings. Screens read from
/// this provider via `context.watch` / `Consumer` rather than talking to
/// [SkillRepository] directly, keeping data-access concerns out of the
/// widget layer.
class SkillProvider extends ChangeNotifier {
  final SkillRepository _repository;

  SkillProvider(this._repository);

  List<SkillModel> _allSkills = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  List<SkillModel> get filteredSkills {
    return _allSkills.where((skill) {
      final matchesCategory =
          _selectedCategory == 'All' || skill.category == _selectedCategory;
      final query = _searchQuery.trim().toLowerCase();
      final matchesQuery = query.isEmpty ||
          skill.title.toLowerCase().contains(query) ||
          skill.description.toLowerCase().contains(query) ||
          skill.category.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  List<SkillModel> skillsByUser(String userId) =>
      _allSkills.where((s) => s.userId == userId).toList();

  SkillModel? byId(String id) {
    try {
      return _allSkills.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> loadSkills() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _allSkills = await _repository.getSkills();
    } catch (e) {
      _error = 'Could not load listings. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addSkill(SkillModel skill) async {
    await _repository.addSkill(skill);
    await loadSkills();
  }

  Future<void> deleteSkill(String skillId) async {
    await _repository.deleteSkill(skillId);
    await loadSkills();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
