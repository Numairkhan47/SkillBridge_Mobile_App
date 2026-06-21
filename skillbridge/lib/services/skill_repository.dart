import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/skill_model.dart';
import '../utils/dummy_data.dart';
import 'storage_service.dart';

/// Repository pattern: the rest of the app depends only on this
/// interface, never on *how* the data is actually fetched/stored. This
/// is exactly the abstraction a real backend integration would sit
/// behind, and is the pattern taught for separating UI from data
/// sources in Flutter apps.
abstract class SkillRepository {
  Future<List<SkillModel>> getSkills();
  Future<void> addSkill(SkillModel skill);
  Future<void> updateSkill(SkillModel skill);
  Future<void> deleteSkill(String skillId);
}

/// Default implementation used by the app out of the box.
///
/// Stores listings on-device using [StorageService] (SharedPreferences),
/// seeded the first time with [DummyData]. This lets the whole app run
/// and persist data with **zero backend setup**, which is ideal for a
/// classroom/demo project, while still honouring the same repository
/// contract a networked implementation would use.
class LocalSkillRepository implements SkillRepository {
  static const _key = 'skillbridge_skills';

  @override
  Future<List<SkillModel>> getSkills() async {
    var raw = StorageService.readJsonList(_key);
    if (raw.isEmpty) {
      final seed = DummyData.seedSkills();
      await StorageService.saveJsonList(_key, seed.map((s) => s.toJson()).toList());
      return seed;
    }
    return raw.map(SkillModel.fromJson).toList();
  }

  @override
  Future<void> addSkill(SkillModel skill) async {
    final current = await getSkills();
    current.insert(0, skill);
    await StorageService.saveJsonList(_key, current.map((s) => s.toJson()).toList());
  }

  @override
  Future<void> updateSkill(SkillModel skill) async {
    final current = await getSkills();
    final index = current.indexWhere((s) => s.id == skill.id);
    if (index != -1) {
      current[index] = skill;
      await StorageService.saveJsonList(_key, current.map((s) => s.toJson()).toList());
    }
  }

  @override
  Future<void> deleteSkill(String skillId) async {
    final current = await getSkills();
    current.removeWhere((s) => s.id == skillId);
    await StorageService.saveJsonList(_key, current.map((s) => s.toJson()).toList());
  }
}

/// Example REST API implementation, included to demonstrate the backend
/// integration concepts covered in the semester (HTTP requests, JSON
/// (de)serialization, error handling).
///
/// This is **not used by default** (see [RepositoryProvider] in
/// `main.dart`) because the project ships without a live server, but it
/// shows exactly how this app would talk to a real backend such as a
/// Node.js/Express + MongoDB API or a Firebase Cloud Functions endpoint.
/// Point [baseUrl] at your own deployed API to switch the whole app over
/// to live data with no other code changes.
class ApiSkillRepository implements SkillRepository {
  final String baseUrl;
  ApiSkillRepository({required this.baseUrl});

  @override
  Future<List<SkillModel>> getSkills() async {
    final response = await http.get(Uri.parse('$baseUrl/skills'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => SkillModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load skills (status ${response.statusCode})');
  }

  @override
  Future<void> addSkill(SkillModel skill) async {
    final response = await http.post(
      Uri.parse('$baseUrl/skills'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(skill.toJson()),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create skill (status ${response.statusCode})');
    }
  }

  @override
  Future<void> updateSkill(SkillModel skill) async {
    final response = await http.put(
      Uri.parse('$baseUrl/skills/${skill.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(skill.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update skill (status ${response.statusCode})');
    }
  }

  @override
  Future<void> deleteSkill(String skillId) async {
    final response = await http.delete(Uri.parse('$baseUrl/skills/$skillId'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete skill (status ${response.statusCode})');
    }
  }
}
