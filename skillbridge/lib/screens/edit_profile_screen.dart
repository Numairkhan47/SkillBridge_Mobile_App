import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import '../utils/validators.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/user_avatar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _bioController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser!;
    _nameController = TextEditingController(text: user.name);
    _locationController = TextEditingController(text: user.location);
    _bioController = TextEditingController(text: user.bio);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final auth = context.read<AuthProvider>();
    final user = auth.currentUser!;
    final updated = UserModel(
      id: user.id,
      name: _nameController.text.trim(),
      email: user.email,
      password: user.password,
      location: _locationController.text.trim(),
      bio: _bioController.text.trim(),
      avatarColorHex: user.avatarColorHex,
      rating: user.rating,
      ratingCount: user.ratingCount,
      skillsOffered: user.skillsOffered,
      favoriteListingIds: user.favoriteListingIds,
      joinedDate: user.joinedDate,
    );

    await auth.updateProfile(updated);

    if (!mounted) return;
    setState(() => _isSaving = false);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser!;
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: UserAvatar(name: _nameController.text.isEmpty ? user.name : _nameController.text,
                      colorHex: user.avatarColorHex, radius: 44),
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'Full Name',
                  controller: _nameController,
                  validator: (v) => Validators.required(v, 'Name'),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Location',
                  controller: _locationController,
                  validator: (v) => Validators.required(v, 'Location'),
                  prefixIcon: const Icon(Icons.location_on_outlined),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Bio',
                  controller: _bioController,
                  maxLines: 3,
                  hint: 'Tell others a bit about yourself',
                ),
                const SizedBox(height: 28),
                PrimaryButton(label: 'Save Changes', isLoading: _isSaving, onPressed: _save),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
