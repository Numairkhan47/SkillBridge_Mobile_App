import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../models/skill_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/skill_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';

/// Form screen for publishing a new listing. Demonstrates a multi-field
/// [Form], a [DropdownButtonFormField], a segmented exchange-type
/// selector built from [ChoiceChip]s, and conditional fields that change
/// based on user selection (price vs. "wanted in exchange").
class PostSkillScreen extends StatefulWidget {
  const PostSkillScreen({super.key});

  @override
  State<PostSkillScreen> createState() => _PostSkillScreenState();
}

class _PostSkillScreenState extends State<PostSkillScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _exchangeController = TextEditingController();

  String _category = AppConstants.categories[1];
  ExchangeType _type = ExchangeType.skillSwap;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _exchangeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final user = auth.currentUser;
    if (user == null) return;

    setState(() => _isSubmitting = true);

    final skill = SkillModel(
      id: const Uuid().v4(),
      userId: user.id,
      title: _titleController.text.trim(),
      category: _category,
      description: _descriptionController.text.trim(),
      type: _type,
      price: _type == ExchangeType.paidGig
          ? double.tryParse(_priceController.text.trim())
          : null,
      wantedInExchange:
          _type == ExchangeType.skillSwap ? _exchangeController.text.trim() : null,
      location: user.location,
      rating: 0,
      completedCount: 0,
    );

    await context.read<SkillProvider>().addSkill(skill);

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    _titleController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _exchangeController.clear();
    setState(() => _type = ExchangeType.skillSwap);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Your listing has been posted! \ud83c\udf89')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post a Skill')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Share what you can teach, fix, build or help with.',
                  style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'Title',
                  controller: _titleController,
                  hint: 'e.g. Beginner Guitar Lessons',
                  validator: (v) => Validators.required(v, 'Title'),
                ),
                const SizedBox(height: 16),
                Text('Category', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: _category,
                  items: AppConstants.categories
                      .where((c) => c != 'All')
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (value) => setState(() => _category = value!),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Description',
                  controller: _descriptionController,
                  hint: 'Describe what you offer and any details people should know.',
                  maxLines: 4,
                  validator: (v) => Validators.required(v, 'Description'),
                ),
                const SizedBox(height: 18),
                const Text('Exchange Type', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: ExchangeType.values.map((t) {
                    final selected = _type == t;
                    return ChoiceChip(
                      label: Text(t.label),
                      selected: selected,
                      onSelected: (_) => setState(() => _type = t),
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : null,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                if (_type == ExchangeType.paidGig)
                  CustomTextField(
                    label: 'Price (Rs.)',
                    controller: _priceController,
                    hint: 'e.g. 1500',
                    keyboardType: TextInputType.number,
                    validator: Validators.price,
                    prefixIcon: const Icon(Icons.payments_outlined),
                  ),
                if (_type == ExchangeType.skillSwap)
                  CustomTextField(
                    label: 'What would you like in exchange?',
                    controller: _exchangeController,
                    hint: 'e.g. Cooking lessons, gardening help',
                    validator: (v) => Validators.required(v, 'This field'),
                    prefixIcon: const Icon(Icons.swap_horiz_rounded),
                  ),
                if (_type == ExchangeType.free)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'This will be listed as free community help \u2014 no payment or trade needed.',
                      style: TextStyle(fontSize: 12.5, color: AppColors.success),
                    ),
                  ),
                const SizedBox(height: 28),
                PrimaryButton(
                  label: 'Publish Listing',
                  icon: Icons.send_rounded,
                  isLoading: _isSubmitting,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
